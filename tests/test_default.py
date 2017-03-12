import testinfra.utils.ansible_runner


testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    '.molecule/ansible_inventory').get_hosts('all')


def test_http_is_installed(Package):
    httpd = Package('httpd')
    assert httpd.is_installed


def test_http_running_and_enabled(Service):
    httpd = Service('httpd')
    assert httpd.is_running
    assert httpd.is_enabled
