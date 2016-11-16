from struct import unpack
from socket import AF_INET, inet_pton


def is_private(ip):
    f = unpack('!I', inet_pton(AF_INET, ip))[0]
    private = (
        [2130706432, 4278190080],  # 127.0.0.0,   255.0.0.0   http://tools.ietf.org/html/rfc3330
        [3232235520, 4294901760],  # 192.168.0.0, 255.255.0.0 http://tools.ietf.org/html/rfc1918
        [2886729728, 4293918720],  # 172.16.0.0,  255.240.0.0 http://tools.ietf.org/html/rfc1918
        [167772160, 4278190080],   # 10.0.0.0,    255.0.0.0   http://tools.ietf.org/html/rfc1918
    )
    for net in private:
        if (f & net[1]) == net[0]:
            return True
    return False
