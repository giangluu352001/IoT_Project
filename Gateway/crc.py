class CRCDetection:
    def __init__(self, polyKey):
        self.polyKey = polyKey
    
    def xor(self, a, b):
        return ''.join([chr(ord(x) ^ ord(y) for x, y in zip(a, b))])
    
    def mod2div(self, divident, divisor):
        pick = len(divisor)
        part = divident[:pick]
        while pick < len(divident):
            if part[0] == '1': part = self.xor(divisor, part) + divident[pick]
            else: part = self.xor('0' * pick, part) + divident[pick]
            pick += 1
        if part[0] == '1': remainder = self.xor(divisor, part)
        else: remainder = self.xor('0' * pick, part)
        return remainder
    
    def isError(self, datastr):
        l_key = len(self.polyKey)
        data = ''.join(format(ord(x), 'b') for x in datastr) + '0' * (l_key - 1)
        remainder = self.mod2div(data, self.polyKey)
        if remainder == '0' * (l_key - 1): return False
        else: return True