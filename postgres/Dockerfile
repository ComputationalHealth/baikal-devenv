FROM library/postgres
RUN apt-get -yqq update
RUN apt-get -yqq install wget
COPY hive.sql pcornet.sql /docker-entrypoint-initdb.d/
WORKDIR /tmp
RUN wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/diagnosis.csv
RUN wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/enrollment.csv
RUN wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/lab_result_cm.csv
RUN wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/procedures.csv
RUN wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/demographic.csv
RUN wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/encounter.csv
RUN wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/prescribing.csv
RUN wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/vital.csv
RUN (head -n1 diagnosis.csv; for i in $(seq 1 $SCALE_PCORNET); do tail -n+2 diagnosis.csv; done) > diagnosis_large.csv
RUN (head -n1 vital.csv; for i in $(seq 1 $SCALE_PCORNET); do tail -n+2 vital.csv; done) > vital_large.csv
WORKDIR /
