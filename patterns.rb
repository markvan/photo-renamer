
PATTERNS = {
    :LENOVO        => /^IMG_(?<year>\d\d\d\d)
                            (?<month>\d\d)
                            (?<day>\d\d)_
                            (?<hour>\d\d)
                            (?<minute>\d\d)
                            (?<second>\d\d)
                            (?<description>)
                            (?<extension>\.jpg)$/x ,

    :LUMIX            => /^P(?<year>)
                            (?<month>)
                            (?<day>)
                            (?<hour>)
                            (?<minute>)
                            (?<second>)
                            (?<description>\d\d\d\d\d\d\d)
                            (?<extension>\.JPG)$/x ,

    :SAMSUNG_ACE        => /(?<year>\d\d\d\d)-
                            (?<month>\d\d)-
                            (?<day>\d\d)[ ]
                            (?<hour>\d\d)\.
                            (?<minute>\d\d)\.
                            (?<second>\d\d)
                            (?<description>)
                            (?<extension>\.jpg)$/x ,

    :SCREEN_SHOT        => /^Screen[ ]Shot[ ]
                            (?<year>\d\d\d\d)-
                            (?<month>\d\d)-
                            (?<day>\d\d)[ ]at[ ]
                            (?<hour>\d\d).
                            (?<minute>\d\d).
                            (?<second>\d\d)
                            (?<description>)
                            (?<extension>\.png)$/x
}


TRANSFORMED =  /^(?<year>\d\d\d\d)-
                              (?<month>\d\d)-
                              (?<day>\d\d)[ ]
                              (?<hour>\d\d)\.
                              (?<minute>\d\d)[ ]*
                              (?<description>.*)[ ]*
                              (?<extension>\..*)$/x
