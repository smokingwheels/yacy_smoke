if [ $PRINTONLY -eq 1 ]; then
    echo $cmdline
else
    echo "****************** YaCy Web Crawler/Indexer & Search Engine *******************"
    echo "**** (C) by Michael Peter Christen, usage granted under the GPL Version 2  ****"
    echo "****   USE AT YOUR OWN RISK! Project home and releases: https://yacy.net/  ****"
    echo "**  LOG of       YaCy: DATA/LOG/yacy00.log (and yacy<xx>.log)                **"
    echo "**  STOP         YaCy: execute stopYACY.sh and wait some seconds             **"
    echo "**  GET HELP for YaCy: join our community at https://community.searchlab.eu  **"
    echo "*******************************************************************************"
    echo "Executing command: $cmdline"
    if [ $DEBUG -eq 1 ] || [ $FOREGROUND -eq 1 ]; then
        exec $cmdline
    else
        echo " >> YaCy started as daemon process. Administration at http://localhost:$PORT << "
        $cmdline
        if [ "$TAILLOG" -eq "1" ] && [ ! "$DEBUG" -eq "1" ]; then
            sleep 1
            tail -f DATA/LOG/yacy00.log
        fi
    fi
fi
