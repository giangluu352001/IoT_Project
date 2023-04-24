import serial.tools.list_ports as list_posts
import serial

class Serial:
    def __init__(self, nameUART, baudrate):
        self.mess = ""
        self.getPort(nameUART)
        self.getSerial(baudrate)
        
    def getPort(self, namUART):
        ports = list_posts.comports()
        num_ports = len(ports)
        self.commPort = "COM3"
        for i in range(0, num_ports):
            port = ports[i]
            strPort = str(port)
            if namUART in strPort:
                splitPort = strPort.split(" ")
                self.commPort = splitPort[0]
                break
    
    def getSerial(self, baudrate):
        self.ser = serial.Serial(port = self.commPort, baudrate = baudrate)
    
    def readSerial(self, client):
        bytesToRead = self.ser.inWaiting()
        if (bytesToRead > 0):
            self.mess = self.mess + self.ser.read(bytesToRead).decode("UTF-8")
            while ("#" in self.mess) and ("!" in self.mess):
                start = self.mess.find("!")
                end = self.mess.find("#")
                self.processData(client, self.mess[start:end + 1])
                if (end == len(self.mess)):
                    self.mess = ""
                else:
                    self.mess = self.mess[end+1:]
                    
    def writeData(self, data):
        self.ser.write(str(data).encode())
        
    def processData(self, client, data):
        data = data.replace("!", "")
        data = data.replace("#", "")
        splitData = data.split(":")
        print(splitData)
        _, key, value = splitData
        if key == "T": client.pushData("temperature", value)
        elif key == "H": client.pushData("humidity", value)

serial = Serial('CP210x', 115200)