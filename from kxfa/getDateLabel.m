function date_label = getDateLabel()

    datetime_1 = strsplit(string(datetime),"-")
    datetime_2 = strsplit(datetime_1(3)," ")
    datetime_3 = strsplit(datetime_2(2),":");
    date_label = ["Y"+datetime_2(1)+"_M"+datetime_1(2)+"_D"+datetime_1(1)+...
        "_h"+datetime_3(1)+"_m"+datetime_3(2)+"_s"+datetime_3(3)]

end