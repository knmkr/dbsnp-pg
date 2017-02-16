from rest_framework.serializers import Serializer, IntegerField, CharField, ListField


class ChrPosSerializer(Serializer):
    snp_id = IntegerField()
    chr = CharField()
    snp_current = IntegerField()
    pos = IntegerField()

class RefSeqSerializer(Serializer):
    orientation = IntegerField()
    accession_ver = IntegerField()
    pos = IntegerField()
    accession = CharField()
    allele = CharField()
    snp_id = IntegerField()
    snp_current = IntegerField()

class Snp3dSerializer(Serializer):
    aa_position = IntegerField()
    contig_res = CharField()
    protein_acc = CharField()
    var_res = CharField()
    snp_id = IntegerField()
    snp_current = IntegerField()

class OmimSerializer(Serializer):
    snp_id = IntegerField()
    snp_current = IntegerField()
    omimvar_id = CharField()
    omim_id = IntegerField()

class SnpSerializer(Serializer):
    dbsnp_ref_genome_build = CharField()
    dbsnp_build = CharField()
    rsid = IntegerField()
    chr_pos = ListField(
        child=ChrPosSerializer()
    )
    refseq = ListField(
        child=RefSeqSerializer()
    )
    snp3d = ListField(
        child=Snp3dSerializer()
    )
    omim = ListField(
        child=OmimSerializer()
    )
