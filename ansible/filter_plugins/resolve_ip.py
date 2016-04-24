import socket

def dns_to_ip(val):
    """
    Resolves DNS to IP address
    """
    return socket.gethostbyname(val)

class FilterModule(object):
    def filters(self):
        return {'dns_to_ip': dns_to_ip}
