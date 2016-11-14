import sys
from os.path import dirname

sys.path.append(dirname(__file__))

from testsupport.openstack_backend import OpenstackBackend
from testinfra.backend import BACKENDS as TESTINFRA_BACKEND_REGISTRY

# register OpenstackBackend to testinfra
# (TODO: publish OpenstackBackend as pytest / testinfra plugin)
TESTINFRA_BACKEND_REGISTRY[OpenstackBackend.get_connection_type()] = OpenstackBackend

# import fixtures
from testsupport.heat_fixture import HeatTemplate, OpenstackSshKey