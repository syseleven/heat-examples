import time
import pytest
import requests


testinfra_hosts = ["core@coreos0", "core@coreos1"]


@pytest.fixture(scope="module", autouse=True)
def HeatCoreos(HeatTemplate, OpenstackSshKey):
    template = HeatTemplate("examples/coreos/cluster.yaml",
                            number_instances=2,
                            key_name=OpenstackSshKey)
    template.create()
    time.sleep(100)
    yield
    template.destroy()


def test_coreos(TestinfraBackend, Socket):
    assert len(TestinfraBackend.public_ipv4) == 1
    assert len(TestinfraBackend.private_ipv4) == 1

    # assert Socket("tcp://80").is_listening
    # assert Socket("tcp://22").is_listening

    r = requests.get('http://{}'.format(TestinfraBackend.public_ipv4[0]))
    assert r.status_code == 200, r
