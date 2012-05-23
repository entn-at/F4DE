# DEVA_cli Profile Configuration file

$VAR1 = [
          '--UsedMetricParameters',
          'CostMiss=80',
          '--UsedMetricParameters',
          'Ptarg=0.001',
          '--UsedMetricParameters',
          'CostFA=1',
          '--taskName',
          'MED',
          '--blockName',
          'EventID',
          '--PrintedBlock',
          'EventID',
          '--derivedSys',
          'DEVAcli_derivedSys_MED12.sql',
          '--FilterCMDfile',
          'DEVAcli_filter-MED12.sql',
          '--JudgementThresholdPerBlock',
          'DEVAcli_scithr-MED12.sql',
          '--KexactlyXderivedSys',
          2,
          '--KQderivedSys',
          'DEVAcli_pfs_MED12-KQderivedSys.perl',
          '--KSysConstraints',
          'DEVAcli_pfs_MED12-KSysConstraints.perl',
          '--KMDConstraints',
          'DEVAcli_pfs_MED12-KMDConstraints.perl',
          '--xmin',
          .1,
          '--Xmax',
          60,
          '--ymin',
          5,
          '--Ymax',
          95
        ];
