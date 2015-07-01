#!/usr/bin/env bash

DATA_DIR=$1

dbsnp_builds=("b142" "b141")
reference_genome_builds=("GRCh38" "GRCh37p13")

usage_exit() {
  echo
  echo "Usage: $0 [-d dbsnp_build] [-r reference_genome_build]"
  echo
  echo "-d dbSNP build version. Set one from (${dbsnp_builds[@]}). Default: ${dbsnp_builds[0]}"
  echo "-r reference genome build version. Set one from (${reference_genome_builds[@]}). Default: ${reference_genome_builds[0]}"
  exit 1
}

while getopts d:r: OPT
do
  case $OPT in
    d)  dbsnp=$OPTARG
        ;;
    r)  ref=$OPTARG
        ;;
    \?) usage_exit
        ;;
  esac
done
shift $((OPTIND - 1))

: ${dbsnp:=${dbsnp_builds[0]}}
: ${ref:=${reference_genome_builds[0]}}

if ! [[ ${dbsnp_builds[*]} =~ "${dbsnp}" ]]; then
  echo "[ERROR] Invalid value for option -d. Not supported dbSNP build."
  usage_exit
elif ! [[ ${reference_genome_builds[*]} =~ "${ref}" ]]; then
  echo "[ERROR] Invalid value for option -r. Not supported reference genome build."
  usage_exit
fi

mkdir -p ${DATA_DIR}
cd ${DATA_DIR}

database="human_9606_${dbsnp}_${ref}"
echo "[INFO] Fetching data for ${database}..."

wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/RsMergeArch.bcp.gz{,.md5}                     # 131 MB
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/Population.bcp.gz{,.md5}                      # 148 kB
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/AlleleFreqBySsPop.bcp.gz{,.md5}               # 1.1 GB
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/dn_PopulationIndGrp.bcp.gz{,.md5}             # 550 B
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/SNPSubSNPLink.bcp.gz{,.md5}                   # 1.8 GB

declare -A _SNPChrPosOnRef=( \
  ["human_9606_b141_GRCh37p13"]="b141_SNPChrPosOnRef_GRCh37p13" \
  ["human_9606_b141_GRCh38"]="b141_SNPChrPosOnRef" \
  ["human_9606_b142_GRCh37p13"]="b142_SNPChrPosOnRef_105" \
  ["human_9606_b142_GRCh38"]="b142_SNPChrPosOnRef_106"
)
wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/${_SNPChrPosOnRef[${database}]}.bcp.gz{,.md5}  # 481 MB
wget -c ftp.ncbi.nih.gov/snp/database/shared_data/Allele.bcp.gz{,.md5}                                                   # 63.1 MB

# optional
# wget -c ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz{,.md5}                                              # 767 B
# wget -c ftp.ncbi.nih.gov/snp/organisms/${database}/database/organism_data/SNPAlleleFreq.bcp.gz{,.md5}                   # 483 MB

echo "[INFO] Checking md5..."

type openssl >/dev/null 2>&1; is_openssl_cmd_found=$?
type md5sum >/dev/null 2>&1; is_md5sum_cmd_found=$?

for src in *.gz; do
  if [ $is_openssl_cmd_found = 0 ]; then
     diff <(openssl md5 ${src}) <(cat ${src}.md5)
  elif [ $is_md5sum_cmd_found = 0 ]; then
     md5sum -c ${src}.md5
  else
    echo "[WARN] Command `openssl` or `md5sum` not found. Skipping md5 check."
    break
  fi
done

# Unifying bcp name
cp ${_SNPChrPosOnRef[${database}]}.bcp.gz SNPChrPosOnRef.bcp.gz

echo "[INFO] Done"
