#!/bin/bash

# Mudando o diretorio para a pasta de backup
cd /home/celosop/Documents

# Calculando a hora e o dia do backup
ident=`date +%Y%m%d%H%M`

while

#!/bin/bash

ident=`date +%Y%m%d%H%M`

cd /home/celosop/Documents/

for item in *
do
        if [ -d "$item" ]
        then
          echo "a pasta $item foi compactada em TAR GZ"
          tar -czvf $item$ident.tar.gz $item
        fi
done


#!/bin/bash
# Script para listar numero de arquivos em cada diretorio em até um subnivel
ident=`date +%Y%m%d%H%M`
# Diretorio a ser trabalhado (pasta local se nao for informado)
pastacaminho='/home/celosop/Documents/'

# Listar somente diretorios
for DIR in $(ls -d $pastacaminho*/data); do
        # Contar número de arquivos do diretório
        NUMDIR=$(ls -lR "$DIR" | grep '^d' | wc -l)
        NUMLIN=$(ls -lR "$DIR" | grep '^l' | wc -l)
        NUMARQ=$(ls -lR "$DIR" | grep '^-' | wc -l)
        # Imprimir saida
        echo $DIR;
        tar -czvf $DIR$ident.tar.gz $DIR
        echo "$DIR: $NUMDIR diretórios, $NUMARQ arquivos e $NUMLIN links simbólicos"
done

# Deixando o backup FULL desabilitado
# Realizando o backup FULL para todos os databases
# mysqldump --password=TKFpoi,@3 --all-databases -c --result-file=/backup/mysql-backup-FULL-$ident.sql > /dev/null

# Realizando a compressao do backup no formato SQL para o TAR GZ
# tar -czvf mysql-backup-FULL-$ident.sql.tar.gz mysql-backup-FULL-$ident.sql





# Obtendo os nomes dos databases instalados no MYSQL
# Os nomes sao gravados em um arquivo temporario "databases.txt"
mysql -u root --password=TKFpoi,@3 -e 'show databases;' > /tmp/databases-names.txt

# Realizando o backup dos databases individualmente
while read LINE # Lendo cada linha (database) do arquivo com os nomes
do
        if [ $LINE != 'Database' ] && [ $LINE != 'sys' ] && [ $LINE != 'information_schema' ] && [ $LINE != 'performance_schema' ]; then
                mysqldump --password=TKFpoi,@3 --databases $LINE -c --result-file=/backup/mysql-backup-$LINE-$ident.sql > /dev/null
                tar -czvf mysql-backup-$LINE-$ident.sql.tar.gz mysql-backup-$LINE-$ident.sql
                rm -rf *.sql
        fi
done < /tmp/databases-names.txt

# Removendo os arquivos com extensao SQL
rm -rf *.sql

# Removendo os backups mais antigos (+20 dias)
# cd /backup
# find -atime +20 -exec rm -vrf {} \;