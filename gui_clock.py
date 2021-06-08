# Clock GUI application
# Based on https://stackoverflow.com/questions/7573031/when-i-use-update-with-tkinter-my-label-writes-another-line-instead-of-rewriti
# python gui_clock.py

import tkinter
import time

class ClockApplication(tkinter.Tk):
    def __init__(self, *args, **kwargs):
        tkinter.Tk.__init__(self, *args, **kwargs)
        self.geometry('256x128')
        self.title('Clock')
        self.clock = tkinter.Label(self, text = '')
        self.clock.pack()

        # start the clock ticking
        self.update_clock()

    def update_clock(self):
        now = time.strftime('%H:%M:%S' , time.gmtime())
        self.clock.configure(text = now)
        # call this function again in one second
        self.after(1000, self.update_clock)

if __name__== "__main__":
    app = ClockApplication()
    app.mainloop()