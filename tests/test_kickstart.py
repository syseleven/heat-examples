import time
import pytest
import testinfra

testinfra_hosts = ["syseleven@kickstart"]


@pytest.fixture(scope="module", autouse=True)
def HeatStack(HeatTemplate, OpenstackSshKey):
    template = HeatTemplate("gettingStarted/sysElevenStackKickstart.yaml",
                            key_name=OpenstackSshKey)
    template.create()
    time.sleep(100)
    yield template.stack_name
    template.destroy()


def test_kickstart(TestinfraBackend, Service):
    assert len(TestinfraBackend.public_ipv4) == 1
    assert len(TestinfraBackend.private_ipv4) == 1

    assert Service("ssh").is_running
