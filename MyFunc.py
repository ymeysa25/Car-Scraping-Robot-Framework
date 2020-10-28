import os
import requests
from datetime import datetime


def saveImage(url, ind, merek, name, row, column):
    page = requests.get(url)
    f_ext = os.path.splitext(url)[-1]
    now = str(datetime.now().date())

    PATH = merek
    try:
        os.mkdir("images/" + PATH)
    except:
        pass

    f_name = 'images/{}/{}_{}_{}_{}_{}{}'.format(PATH, name, row, column, ind, now, f_ext)
    # try:
    with open(f_name, 'wb') as f:
        f.write(page.content)


def getNumber(text):
    return int(text.split(" / ")[1])
