#!/usr/bin/env bash

set -e
set -o pipefail

dbsnp_builds=("b149" "b147" "b146")
reference_genome_builds=("GRCh38" "GRCh37")

usage_exit() {
  echo "Usage: $0 [-d dbsnp_build] [-r reference_genome_build] <data_dir>"                                                        >&2
  echo                                                                                                                            >&2
  echo "-d dbSNP build version. Set one from (${dbsnp_builds[@]}). Default: ${dbsnp_builds[0]}"                                   >&2
  echo "-r reference genome build version. Set one from (${reference_genome_builds[@]}). Default: ${reference_genome_builds[0]}"  >&2
  exit 1
}

# Parse args
while getopts ":d:r:" OPT; do
  case "${OPT}" in
    d)  dbsnp=${OPTARG};;
    r)  ref=${OPTARG};;
    \?) usage_exit;;
  esac
done
shift $((OPTIND - 1))

if [ "$#" -ne 1 ]; then
    usage_exit
fi

# Requirements: wget
if type wget >/dev/null 2>/dev/null; then
  :
else
  echo "[FATAL] `date +"%Y-%m-%d %H:%M:%S"` Command not found: wget"
  exit 1
fi

# Set defaults
: ${dbsnp:=${dbsnp_builds[0]}}
: ${ref:=${reference_genome_builds[0]}}

# TODO: check dbsnp_builds and reference_genome_builds in choices
# Check args
data_dir=$1
if [ -z "${data_dir}" ]; then
    usage_exit
fi

mkdir -p ${data_dir}
cd ${data_dir}

database="${dbsnp}_${ref}"
echo "[INFO] Fetching data for ${database} to ${data_dir}..."

declare -A ftp_main=( \
  ["b146_GRCh37"]="human_9606_b146_GRCh37p13" \
  ["b147_GRCh37"]="human_9606_b146_GRCh37p13" \
  ["b149_GRCh37"]="human_9606_b146_GRCh37p13" \

  ["b146_GRCh38"]="human_9606_b146_GRCh38p2"  \
  ["b147_GRCh38"]="human_9606_b147_GRCh38p2"  \
  ["b149_GRCh38"]="human_9606_b149_GRCh38p7"  \
)

declare -A ftp_branch=( \
  ["b146_GRCh37"]="human_9606_b146_GRCh37p13" \
  ["b147_GRCh37"]="human_9606_b147_GRCh37p13" \
  ["b149_GRCh37"]="human_9606_b149_GRCh37p13" \

  ["b146_GRCh38"]="human_9606_b146_GRCh38p2"  \
  ["b147_GRCh38"]="human_9606_b147_GRCh38p2"  \
  ["b149_GRCh38"]="human_9606_b149_GRCh38p7"  \
)

declare -A ref_code=( \
  ["b146_GRCh37"]="105" \
  ["b147_GRCh37"]="105" \
  ["b149_GRCh37"]="105" \

  ["b146_GRCh38"]="107"  \
  ["b147_GRCh38"]="107"  \
  ["b149_GRCh38"]="108"  \
)

wget -c ftp.ncbi.nih.gov/snp/organisms/${ftp_main[${database}]}/database/organism_data/OmimVarLocusIdSNP.bcp.gz{,.md5}                                   # ~200 KB
wget -c ftp.ncbi.nih.gov/snp/organisms/${ftp_main[${database}]}/database/organism_data/RsMergeArch.bcp.gz{,.md5}                                         # ~150 MB
wget -c ftp.ncbi.nih.gov/snp/organisms/${ftp_main[${database}]}/database/organism_data/SNP.bcp.gz{,.md5}                                                 # ~1.7 GB
wget -c ftp.ncbi.nih.gov/snp/organisms/${ftp_main[${database}]}/database/organism_data/SNP3D.bcp.gz{,.md5}                                               #  ~18 MB
wget -c ftp.ncbi.nih.gov/snp/organisms/${ftp_branch[${database}]}/database/organism_data/${dbsnp}_ContigInfo_${ref_code[${database}]}.bcp.gz{,.md5}      # ~141 KB
wget -c ftp.ncbi.nih.gov/snp/organisms/${ftp_branch[${database}]}/database/organism_data/${dbsnp}_MapLinkInfo_${ref_code[${database}]}.bcp.gz{,.md5}     # ~970 KB
wget -c ftp.ncbi.nih.gov/snp/organisms/${ftp_branch[${database}]}/database/organism_data/${dbsnp}_MapLink_${ref_code[${database}]}.bcp.gz{,.md5}         # ~1.2 GB
wget -c ftp.ncbi.nih.gov/snp/organisms/${ftp_branch[${database}]}/database/organism_data/${dbsnp}_SNPChrPosOnRef_${ref_code[${database}]}.bcp.gz{,.md5}  # ~500 MB
wget -c ftp.ncbi.nih.gov/snp/organisms/${ftp_branch[${database}]}/database/organism_data/${dbsnp}_SNPContigLoc_${ref_code[${database}]}.bcp.gz{,.md5}    # ~3.3 GB
wget -c ftp.ncbi.nih.gov/snp/database/shared_data/Allele.bcp.gz{,.md5}                                                                                   #  ~70 MB
wget -c ftp.ncbi.nih.gov/snp/database/shared_data/SnpChrCode.bcp.gz{,.md5}                                                                               #   ~1 KB

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
ln -s ${dbsnp}_ContigInfo_${ref_code[${ref}]}.bcp.gz     ContigInfo.bcp.gz
ln -s ${dbsnp}_MapLinkInfo_${ref_code[${ref}]}.bcp.gz    MapLinkInfo.bcp.gz
ln -s ${dbsnp}_MapLink_${ref_code[${ref}]}.bcp.gz        MapLink.bcp.gz
ln -s ${dbsnp}_SNPChrPosOnRef_${ref_code[${ref}]}.bcp.gz SNPChrPosOnRef.bcp.gz
ln -s ${dbsnp}_SNPContigLoc_${ref_code[${ref}]}.bcp.gz   SNPContigLoc.bcp.gz

echo "[INFO] Done"
