SELECT
    snp_id,
    af.subsnp_id,
    po.loc_pop_id,
    source,
    al.allele AS ss_allele,
    CASE
        WHEN ss2rs.substrand_reversed_flag = '0' THEN
            al.allele
        ELSE
            (SELECT allele FROM Allele WHERE allele_id = al.rev_allele_id)
        END AS rs_allele_id,
    freq
FROM
    SNPSubSNPLink ss2rs
    JOIN AlleleFreqBySsPop af ON af.subsnp_id = ss2rs.subsnp_id
    JOIN Population po ON af.pop_id = po.pop_id
    JOIN Allele al ON af.allele_id = al.allele_id
    JOIN dn_PopulationIndGrp pop2grp ON af.pop_id = pop2grp.pop_id
WHERE
    snp_id = 10
    AND pop2grp.ind_grp_name = 'Asian';
