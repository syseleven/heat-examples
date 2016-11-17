import random
import string
import pytest


def randomword(length):
    return ''.join(random.choice(string.lowercase) for _ in range(length))


def local_run_expect(*args, **kwargs):
    import testinfra.plugin
    local_run_expect = testinfra.get_backend("local://").get_module("Command").run_expect
    return local_run_expect(*args, **kwargs)


@pytest.fixture(scope="module")
def HeatTemplate():
    from openstack_backend import OpenstackBackend
    class Template:
        def __init__(self, yaml, **parameters):
            self.yaml = yaml
            self.parameters = parameters
            self.stack_name = "testinfra_" + randomword(10)

        def create(self):
            # TODO: find a cleaner solution
            OpenstackBackend.stack_name = self.stack_name

            parameters_string = " ".join(
                map(lambda key: "--parameter {key}={value}".format(key=key, value=self.parameters[key]),
                    self.parameters.keys()))

            create_command = "openstack stack create -t {yaml} {stack_name} {params} --wait".format(
                                    yaml=self.yaml,
                                    stack_name=self.stack_name,
                                    params=parameters_string
                                )
            local_run_expect([0], create_command)

        def destroy(self):
            # TODO: find a cleaner solution
            OpenstackBackend.stack_name = None

            delete_command = "openstack stack delete --yes {stack_name}".format(
                                    stack_name=self.stack_name
                                )
            local_run_expect([0], delete_command)

    return Template


@pytest.fixture(scope="session")
def OpenstackSshKey():
    keyname = "testinfra_" + randomword(10)

    command = "rm ssh_rsa{0} ssh_rsa{0}.pub || true".format(keyname)
    local_run_expect([0], command)

    command = "ssh-keygen -t rsa -N '' -f ./ssh_rsa{}".format(keyname)
    local_run_expect([0], command)

    command = "openstack keypair create {0} --public-key ./ssh_rsa{0}.pub".format(keyname)
    local_run_expect([0], command)

    command = "ssh-add -D"
    local_run_expect([0], command)

    command = "ssh-add ./ssh_rsa{}".format(keyname)
    local_run_expect([0], command)

    yield keyname

    command = "rm ssh_rsa{0} ssh_rsa{0}.pub".format(keyname)
    local_run_expect([0], command)

    command = "openstack keypair delete {}".format(keyname)
    local_run_expect([0], command)