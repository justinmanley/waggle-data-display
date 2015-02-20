from time import gmtime, strftime
import random
from commands import getoutput as bashit

try:
    currentFilePtr = open('./current/current', 'w+')
except:
    bashit('mkdir current')
    currentFilePtr = open('./current/current', 'w+')

current_time = strftime("%m/%d/%y %H:%M:%S", gmtime())
Temperature_value = random.uniform(-40,60)
Temp_C = str("{0:.2f}".format(Temperature_value))
Temp_F = str("{0:.2f}".format(Temperature_value * 1.8 + 31))

MLX90614ESF='MLX90614ESF-DAA.Melexis.008-2013,'+current_time+',Temperature;'+Temp_F+';F;none\n'
TMP421='TMP421.Texas_Instruments.2012,'+current_time+',Temperature;'+Temp_C+';C;none\n'
BMP180='BMP180.Bosch.2_5-2013,'+current_time+',Temperature;'+Temp_C+';C;none,Pressure;'+str(random.uniform(999120,1000000))+';PA;Barometric\n'
MMA8452Q='MMA8452Q.Freescale.8_1-2013,'+current_time+',Acceleration;'+str("{0:.2f}".format(random.uniform(-10,10)))+';g;X,Acceleration;'+str("{0:.2f}".format(random.uniform(-10,10)))+';g;Y,Acceleration;'+str("{0:.2f}".format(random.uniform(-10,10)))+';g;Z,Vibration;'+str("{0:.2f}".format(random.uniform(0,10)))+';g;RMS_3Axis\n'
PDV_P8104='PDV_P8104.API.2006,'+current_time+',Luminous_Intensity;'+str(random.randint(0,1024))+';Units10B0V5;Voltage_Divider_5V_PDV_Tap_4K7_GND\n'
PR103J2='Thermistor_NTC_PR103J2.US_Sensor.2003,'+current_time+',Temperature;'+str(random.randint(0,1024))+';Units10B0V5;Voltage_Divider_5V_NTC_Tap_68K_GND\n'
HIH6130='HIH6130.Honeywell.2011,'+current_time+',Temperature;'+Temp_C+';C;none,Humidity;'+str(random.randint(0,1024))+';%RH;none\n'
SHT15='SHT15.Sensirion.4_3-2010,'+current_time+',Temperature;'+Temp_C+';C;none,Humidity;'+str(random.randint(0,1024))+';%RH;RH\n'
HTU21D=SHT15='HTU21D.MeasSpec.2013,'+current_time+',Temperature;'+Temp_C+';C;none,Humidity;'+str(random.randint(0,1024))+';%RH;RH\n'
DS18B20='DS18B20.Maxim.2008,'+current_time+',Temperature;'+Temp_C+';C;none\n'
RHT03='RHT03.Maxdetect.2011,'+current_time+',Temperature;'+Temp_C+';C;none,Humidity;'+str(random.randint(0,1024))+';%RH;RH\n'
TMP102='TMP102.Texas_Instruments.2008,'+current_time+',Temperature;'+Temp_F+';F;none\n'
SHT75='SHT75.Sensirion.5_2011,'+current_time+',Temperature;'+Temp_C+';C;none,Humidity;'+str(random.randint(0,1024))+';%RH;RH\n'
HIH4030='HIH4030.Honeywell.2008,'+current_time+',Humidity;'+str(random.randint(0,1024))+';Units10B0V5;RH\n'
GA1A1S201WP='GA1A1S201WP.Sharp.2007,'+current_time+',Luminous_Intensity;'+str(random.randint(0,1024))+';Units10B0V5;non-standard\n'
MAX4466='MAX4466.Maxim.2001,'+current_time+',Acoustic_Intensity;'+str(random.randint(0,1024))+';Units10B0V5;non-standard\n'
D6T44L06='D6T-44L-06.Omron.2012,'+current_time+',Temperature;'+Temp_C+';C;PTAT,Temperature;'+Temp_C+';C;1x1,Temperature;'+Temp_C+';C;1x2,Temperature;'+Temp_C+';C;1x3,Temperature;'+Temp_C+';C;1x4,Temperature;'+Temp_C+';C;2x1,Temperature;'+Temp_C+';C;2x2,Temperature;'+Temp_C+';C;2x3,Temperature;'+Temp_C+';C;2x4,Temperature;'+Temp_C+';C;3x1,Temperature;'+Temp_C+';C;3x2,Temperature;'+Temp_C+';C;3x3,Temperature;'+Temp_C+';C;3x4,Temperature;'+Temp_C+';C;4x1,Temperature;'+Temp_C+';C;4x2,Temperature;'+Temp_C+';C;4x3,Temperature;'+Temp_C+';C;4x4\n'
HMC5883='HMC5883.Honeywell.2013,'+current_time+',MagneticField;'+str("{0:.2f}".format(random.uniform(-8,8)))+';gauss;X,MagneticField;'+str("{0:.2f}".format(random.uniform(-8,8)))+';gauss;Y,MagneticField;'+str("{0:.2f}".format(random.uniform(-8,8)))+';gauss;Z\n'

currentFilePtr.write(BMP180+DS18B20+HIH4030+HIH6130+D6T44L06+GA1A1S201WP+MAX4466+MLX90614ESF+PDV_P8104+PR103J2+SHT15+SHT75+TMP102+TMP421+RHT03+MMA8452Q+HTU21D+HMC5883)
currentFilePtr.close()

try:
    historical_prt = open('./historical/BMP180', 'a+')
except:
    bashit('mkdir historical')
    historical_prt = open('./historical/BMP180', 'a+')

historical_prt.write(BMP180)
historical_prt.close()

historical_prt = open('./historical/D6T44L06', 'a+')
historical_prt.write(D6T44L06)
historical_prt.close()

historical_prt = open('./historical/DS18B20', 'a+')
historical_prt.write(DS18B20)
historical_prt.close()

historical_prt = open('./historical/GA1A1S201WP', 'a+')
historical_prt.write(GA1A1S201WP)
historical_prt.close()

historical_prt = open('./historical/HIH4030', 'a+')
historical_prt.write(HIH4030)
historical_prt.close()

historical_prt = open('./historical/HIH6130', 'a+')
historical_prt.write(HIH6130)
historical_prt.close()

historical_prt = open('./historical/MAX4466', 'a+')
historical_prt.write(MAX4466)
historical_prt.close()

historical_prt = open('./historical/MLX90614ESF', 'a+')
historical_prt.write(MLX90614ESF)
historical_prt.close()

historical_prt = open('./historical/MMA8452Q', 'a+')
historical_prt.write(MMA8452Q)
historical_prt.close()

historical_prt = open('./historical/PDV_P8104', 'a+')
historical_prt.write(PDV_P8104)
historical_prt.close()

historical_prt = open('./historical/RHT03', 'a+')
historical_prt.write(RHT03)
historical_prt.close()

historical_prt = open('./historical/SHT15', 'a+')
historical_prt.write(SHT15)
historical_prt.close()

historical_prt = open('./historical/SHT75', 'a+')
historical_prt.write(SHT75)
historical_prt.close()

historical_prt = open('./historical/PR103J2', 'a+')
historical_prt.write(PR103J2)
historical_prt.close()

historical_prt = open('./historical/TMP102', 'a+')
historical_prt.write(TMP102)
historical_prt.close()

historical_prt = open('./historical/TMP421', 'a+')
historical_prt.write(TMP421)
historical_prt.close()

historical_prt = open('./historical/HMC5883', 'a+')
historical_prt.write(HMC5883)
historical_prt.close()

historical_prt = open('./historical/HTU21D', 'a+')
historical_prt.write(HTU21D)
historical_prt.close()

