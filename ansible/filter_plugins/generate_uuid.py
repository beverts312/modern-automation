import uuid

def generate_uuid(num):
    """
    Resolves DNS to IP address
    """
    return [str(uuid.uuid4()) for i in xrange(0,num)]

class FilterModule(object):
    def filters(self):
        return {'generate_uuid': generate_uuid}