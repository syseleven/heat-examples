# based on https://github.com/philpep/testinfra/blob/master/testinfra/backend/salt.py

from __future__ import absolute_import
from __future__ import unicode_literals

import fnmatch
import os

try:
    import novaclient.client
    import heatclient.client
    from keystoneclient.v3 import client as keystone_client
    from keystoneauth1 import session
    from keystoneauth1.identity import v3
except ImportError:
    HAS_OPENSTACK = False
else:
    HAS_OPENSTACK = True

from testinfra.backend import ssh
from testinfra.backend import paramiko
from testinfra.backend import base

from testsupport.ip_lookup import is_private


class OpenstackBackend(base.BaseBackend):
    stack_name = None

    NAME = "openstack"

    def __init__(self, hostspec, ssh_config=None, stack_name=None, *args, **kwargs):
        self.host, self.user, self.port = self.parse_hostspec(hostspec)
        self._nova_client = None
        self._heat_client = None
        self._init_args = args
        self._init_kwargs = kwargs
        self._ssh_backend = None
        self._all_ipv4 = None
        self.ssh_config = ssh_config
        #self.stack_name = stack_name
        super(OpenstackBackend, self).__init__(self.host, *args, **kwargs)

    def run(self, command, *args):
        if not self._ssh_backend:
            #self._ssh_backend = ssh.SshBackend(self._real_hostspec, *self._init_args, **self._init_kwargs)
            self._ssh_backend = paramiko.ParamikoBackend(self._real_hostspec, *self._init_args, **self._init_kwargs)

        return self._ssh_backend.run(command, *args)

    @classmethod
    def get_hosts(cls, host, **kwargs):
        if host is None:
            host = "*"

        if any([c in host for c in "[?]*"]):
            client = cls._get_nova_client()

            all_hosts = [h.name for h in client.servers.list()]
            hosts = fnmatch.filter(all_hosts, host)

            if len(hosts) == 0:
                raise RuntimeError("No host matching '%s'" % (host,))

            return sorted(hosts)
        else:
            return super(OpenstackBackend, cls).get_hosts(host, **kwargs)

    @property
    def private_ipv4(self):
        return [ip for ip in self.all_ipv4 if is_private(ip)]

    @property
    def public_ipv4(self):
        return [ip for ip in self.all_ipv4 if not is_private(ip)]

    @property
    def all_ipv4(self):
        if self._all_ipv4 is None:
            server = self.get_server_by_name(self.host)

            self._all_ipv4 = [ip_address
                              for network in server.networks.values()
                              for ip_address in network]

        return self._all_ipv4

    def get_server_by_name(self, name):
        assert self.stack_name is not None, "no stack name - did you use the HeatTemplate fixture?"
        servers = [server for server in self.nova_client.servers.list() if server.name == name]
        resources_in_stack = self.heat_client.resources.list(self.stack_name, nested_depth=9999)

        server_ids_in_stack = [resource.physical_resource_id for resource in resources_in_stack if resource.resource_type == "OS::Nova::Server"]
        servers_in_stack = [server for server in servers if server.id in server_ids_in_stack]

        assert len(servers_in_stack) > 0, "Did not find a server named %s in stack %s" % (name, self.stack_name)
        assert len(servers_in_stack) == 1, "More than one server is named %s in stack %s" % (name, self.stack_name)

        return servers_in_stack[0]

    # ==== from now on everything is private
    @property
    def _real_hostspec(self):
        hostspec = ""

        if self.user:
            hostspec += "%s@" % self.user

        hostspec += self.public_ipv4[0]

        if self.port:
            hostspec += ":%s" % self.port

        return hostspec


    @property
    def nova_client(self):
        if self._nova_client is None:
            self._nova_client = self._get_nova_client()

        return self._nova_client


    @property
    def heat_client(self):
        if self._heat_client is None:
            self._heat_client = self._get_heat_client()

        return self._heat_client


    @classmethod
    def _get_nova_client(cls):
        cls._check_openstack()
        cls._check_credentials()

        authpass = v3.Password(
            auth_url=os.environ['OS_AUTH_URL'] + '/v3',
            username=os.environ['OS_USERNAME'],
            password=os.environ['OS_PASSWORD'],
            project_name=os.environ['OS_TENANT_NAME'],
            project_domain_id="default",
            user_domain_id="default"
        )
        authsession = session.Session(auth=authpass)

        nova_client = novaclient.client.Client(
            version=2,
            session=authsession
        )

        return nova_client

    @classmethod
    def _get_heat_client(cls):
        cls._check_openstack()
        cls._check_credentials()

        authpass = v3.Password(
            auth_url=os.environ['OS_AUTH_URL'] + '/v3',
            username=os.environ['OS_USERNAME'],
            password=os.environ['OS_PASSWORD'],
            project_name=os.environ['OS_TENANT_NAME'],
            project_domain_id="default",
            user_domain_id="default"
        )
        authsession = session.Session(auth=authpass)

        try:
            target_client = keystone_client.Client(session=authsession, interface="public", region_name="zbk")
            target_client.roles.list()
        except:
            pass
        endpoints = authpass.auth_ref.service_catalog.get_endpoints(interface="public")
        heat_url = endpoints.get('orchestration')[0].get('url')

        heat_client = heatclient.client.Client(
            version=1,
            endpoint=heat_url,
            session=authsession
        )

        return heat_client

    @classmethod
    def _check_openstack(cls):
        if not HAS_OPENSTACK:
            raise RuntimeError(
                "You must install python-openstacksdk, python-heatclient and \
                python-novaclient packages to use the openstack backend")

    @classmethod
    def _check_credentials(cls):
        required_vars = ['OS_AUTH_URL', 'OS_USERNAME', 'OS_PASSWORD', 'OS_TENANT_NAME']

        for required_var in required_vars:
            if not os.environ.has_key(required_var) \
                    or not os.environ[required_var]:
                raise RuntimeError(
                    """You must provide the openstack credentials
              (environment variable '%s' missing)""" % required_var)
