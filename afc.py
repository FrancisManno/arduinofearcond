from Tkinter import *
import serial
import time
from threading import Thread


myserial = None
monitor_running = True;

class SerialMonitor(Thread):
	def __init__(self):
		print "Monitor started"
		Thread.__init__(self)

	def run(self):
		while (monitor_running):
			if (myserial.inWaiting()>0):
				sstr = ''
				while (myserial.inWaiting()>0):
					sstr +=  myserial.read()
				print sstr
			time.sleep(0.3)



class AFC:
	def __init__(self, master):
		self.frame = Frame(master)
		self.frame.pack()
		
		Label(self.frame, text="Delay before Sound:").pack()
		self.before_sound = Entry(self.frame);
		self.before_sound.insert(0, '1000')
		self.before_sound.pack()

		Label(self.frame, text="Sound Duration: (enter 0 to disable shock)").pack()
		self.sound_duration = Entry(self.frame);
		self.sound_duration.insert(0, '2000')
		self.sound_duration.pack()

		Label(self.frame, text="Shock Duration (enter 0 to disable shock):").pack()
		self.shock_duration = Entry(self.frame);
		self.shock_duration.insert(0, '600')
		self.shock_duration.pack()

		Label(self.frame, text="Frequency:").pack()
		self.freqs = Entry(self.frame);
		self.freqs.insert(0, '343')
		self.freqs.pack()

		Label(text="Review the settings and press Fire")


		#Button(self.frame, text='Abort', command=self.abort).pack()
		Button(self.frame, text='Fire', command=self.fire).pack()
		Button(self.frame, text='Quit', command=self.frame.quit).pack()



	def fire(self):
		print "Fire!"
		before = int(self.before_sound.get())
		sound = int(self.sound_duration.get())
		shock = int(self.shock_duration.get())
		freqs = int(self.freqs.get())
		ss = "SET,%d,%d,%d,%d,K\n" %(before, sound, shock, freqs)
		print ">> ", ss
		myserial.write(ss)
		myserial.flush()

	def abort(self):
		print "Abort abort!"
		self.frame.quit()

myserial =  serial.Serial(port="COM4", baudrate=9600, timeout=1, dsrdtr=True)



root=Tk()
app = AFC(root)

mon = SerialMonitor()
mon.start()
root.mainloop()

monitor_running = False;
myserial.close()


