@expected_year = ( "2009" );
@expected_task = ( "retroED" );
@expected_data = ( "DEV09", "EVAL09" ); # keep Order
@expected_lang = ( "ENG" );
@expected_input = ( "s-camera" );
@expected_sysid_beg = ( "p-", "c-" );

@expected_dir_output = ( "output" );

%expected_sffn = 
  (
   $expected_data[0] =>
   {
    'LGW_20071101_E1_CAM1' => 'LGW_20071101_E1_CAM1.mpeg',
    'LGW_20071101_E1_CAM2' => 'LGW_20071101_E1_CAM2.mpeg',
    'LGW_20071101_E1_CAM3' => 'LGW_20071101_E1_CAM3.mpeg',
    'LGW_20071101_E1_CAM4' => 'LGW_20071101_E1_CAM4.mpeg',
    'LGW_20071101_E1_CAM5' => 'LGW_20071101_E1_CAM5.mpeg',
    'LGW_20071106_E1_CAM1' => 'LGW_20071106_E1_CAM1.mpeg',
    'LGW_20071106_E1_CAM2' => 'LGW_20071106_E1_CAM2.mpeg',
    'LGW_20071106_E1_CAM3' => 'LGW_20071106_E1_CAM3.mpeg',
    'LGW_20071106_E1_CAM4' => 'LGW_20071106_E1_CAM4.mpeg',
    'LGW_20071106_E1_CAM5' => 'LGW_20071106_E1_CAM5.mpeg',
    'LGW_20071107_E1_CAM1' => 'LGW_20071107_E1_CAM1.mpeg',
    'LGW_20071107_E1_CAM2' => 'LGW_20071107_E1_CAM2.mpeg',
    'LGW_20071107_E1_CAM3' => 'LGW_20071107_E1_CAM3.mpeg',
    'LGW_20071107_E1_CAM4' => 'LGW_20071107_E1_CAM4.mpeg',
    'LGW_20071107_E1_CAM5' => 'LGW_20071107_E1_CAM5.mpeg',
    'LGW_20071108_E1_CAM1' => 'LGW_20071108_E1_CAM1.mpeg',
    'LGW_20071108_E1_CAM2' => 'LGW_20071108_E1_CAM2.mpeg',
    'LGW_20071108_E1_CAM3' => 'LGW_20071108_E1_CAM3.mpeg',
    'LGW_20071108_E1_CAM4' => 'LGW_20071108_E1_CAM4.mpeg',
    'LGW_20071108_E1_CAM5' => 'LGW_20071108_E1_CAM5.mpeg',
    'LGW_20071112_E1_CAM1' => 'LGW_20071112_E1_CAM1.mpeg',
    'LGW_20071112_E1_CAM2' => 'LGW_20071112_E1_CAM2.mpeg',
    'LGW_20071112_E1_CAM3' => 'LGW_20071112_E1_CAM3.mpeg',
    'LGW_20071112_E1_CAM4' => 'LGW_20071112_E1_CAM4.mpeg',
    'LGW_20071112_E1_CAM5' => 'LGW_20071112_E1_CAM5.mpeg',
    'LGW_20071123_E1_CAM1' => 'LGW_20071123_E1_CAM1.mpeg',
    'LGW_20071123_E1_CAM2' => 'LGW_20071123_E1_CAM2.mpeg',
    'LGW_20071123_E1_CAM3' => 'LGW_20071123_E1_CAM3.mpeg',
    'LGW_20071123_E1_CAM4' => 'LGW_20071123_E1_CAM4.mpeg',
    'LGW_20071123_E1_CAM5' => 'LGW_20071123_E1_CAM5.mpeg',
    'LGW_20071130_E1_CAM1' => 'LGW_20071130_E1_CAM1.mpeg',
    'LGW_20071130_E1_CAM2' => 'LGW_20071130_E1_CAM2.mpeg',
    'LGW_20071130_E1_CAM3' => 'LGW_20071130_E1_CAM3.mpeg',
    'LGW_20071130_E1_CAM4' => 'LGW_20071130_E1_CAM4.mpeg',
    'LGW_20071130_E1_CAM5' => 'LGW_20071130_E1_CAM5.mpeg',
    'LGW_20071130_E2_CAM1' => 'LGW_20071130_E2_CAM1.mpeg',
    'LGW_20071130_E2_CAM2' => 'LGW_20071130_E2_CAM2.mpeg',
    'LGW_20071130_E2_CAM3' => 'LGW_20071130_E2_CAM3.mpeg',
    'LGW_20071130_E2_CAM4' => 'LGW_20071130_E2_CAM4.mpeg',
    'LGW_20071130_E2_CAM5' => 'LGW_20071130_E2_CAM5.mpeg',
    'LGW_20071206_E1_CAM1' => 'LGW_20071206_E1_CAM1.mpeg',
    'LGW_20071206_E1_CAM2' => 'LGW_20071206_E1_CAM2.mpeg',
    'LGW_20071206_E1_CAM3' => 'LGW_20071206_E1_CAM3.mpeg',
    'LGW_20071206_E1_CAM4' => 'LGW_20071206_E1_CAM4.mpeg',
    'LGW_20071206_E1_CAM5' => 'LGW_20071206_E1_CAM5.mpeg',
    'LGW_20071207_E1_CAM1' => 'LGW_20071207_E1_CAM1.mpeg',
    'LGW_20071207_E1_CAM2' => 'LGW_20071207_E1_CAM2.mpeg',
    'LGW_20071207_E1_CAM3' => 'LGW_20071207_E1_CAM3.mpeg',
    'LGW_20071207_E1_CAM4' => 'LGW_20071207_E1_CAM4.mpeg',
    'LGW_20071207_E1_CAM5' => 'LGW_20071207_E1_CAM5.mpeg',
   },
   $expected_data[1] =>
   { 
    'MCTTR0101a' => ' MCTTR0101a.mov.deint.mpeg',
    'MCTTR0102a' => ' MCTTR0102a.mov.deint.mpeg',
    'MCTTR0103a' => ' MCTTR0103a.mov.deint.mpeg',
    'MCTTR0104a' => ' MCTTR0104a.mov.deint.mpeg',
    'MCTTR0105a' => ' MCTTR0105a.mov.deint.mpeg',
    'MCTTR0101b' => ' MCTTR0101b.mov.deint.mpeg',
    'MCTTR0102b' => ' MCTTR0102b.mov.deint.mpeg',
    'MCTTR0103b' => ' MCTTR0103b.mov.deint.mpeg',
    'MCTTR0104b' => ' MCTTR0104b.mov.deint.mpeg',
    'MCTTR0105b' => ' MCTTR0105b.mov.deint.mpeg',
    'MCTTR0101c' => ' MCTTR0101c.mov.deint.mpeg',
    'MCTTR0102c' => ' MCTTR0102c.mov.deint.mpeg',
    'MCTTR0103c' => ' MCTTR0103c.mov.deint.mpeg',
    'MCTTR0104c' => ' MCTTR0104c.mov.deint.mpeg',
    'MCTTR0105c' => ' MCTTR0105c.mov.deint.mpeg',
    'MCTTR0101d' => ' MCTTR0101d.mov.deint.mpeg',
    'MCTTR0102d' => ' MCTTR0102d.mov.deint.mpeg',
    'MCTTR0103d' => ' MCTTR0103d.mov.deint.mpeg',
    'MCTTR0104d' => ' MCTTR0104d.mov.deint.mpeg',
    'MCTTR0105d' => ' MCTTR0105d.mov.deint.mpeg',
    'MCTTR0101e' => ' MCTTR0101e.mov.deint.mpeg',
    'MCTTR0102e' => ' MCTTR0102e.mov.deint.mpeg',
    'MCTTR0103e' => ' MCTTR0103e.mov.deint.mpeg',
    'MCTTR0104e' => ' MCTTR0104e.mov.deint.mpeg',
    'MCTTR0105e' => ' MCTTR0105e.mov.deint.mpeg',
    'MCTTR0101f' => ' MCTTR0101f.mov.deint.mpeg',
    'MCTTR0102f' => ' MCTTR0102f.mov.deint.mpeg',
    'MCTTR0103f' => ' MCTTR0103f.mov.deint.mpeg',
    'MCTTR0104f' => ' MCTTR0104f.mov.deint.mpeg',
    'MCTTR0105f' => ' MCTTR0105f.mov.deint.mpeg',
    'MCTTR0101g' => ' MCTTR0101g.mov.deint.mpeg',
    'MCTTR0102g' => ' MCTTR0102g.mov.deint.mpeg',
    'MCTTR0103g' => ' MCTTR0103g.mov.deint.mpeg',
    'MCTTR0104g' => ' MCTTR0104g.mov.deint.mpeg',
    'MCTTR0105g' => ' MCTTR0105g.mov.deint.mpeg',
    'MCTTR0101h' => ' MCTTR0101h.mov.deint.mpeg',
    'MCTTR0102h' => ' MCTTR0102h.mov.deint.mpeg',
    'MCTTR0103h' => ' MCTTR0103h.mov.deint.mpeg',
    'MCTTR0104h' => ' MCTTR0104h.mov.deint.mpeg',
    'MCTTR0105h' => ' MCTTR0105h.mov.deint.mpeg',
    'MCTTR0101i' => ' MCTTR0101i.mov.deint.mpeg',
    'MCTTR0102i' => ' MCTTR0102i.mov.deint.mpeg',
    'MCTTR0103i' => ' MCTTR0103i.mov.deint.mpeg',
    'MCTTR0104i' => ' MCTTR0104i.mov.deint.mpeg',
    'MCTTR0105i' => ' MCTTR0105i.mov.deint.mpeg',
    'MCTTR0201a' => ' MCTTR0201a.mov.deint.mpeg',
    'MCTTR0202a' => ' MCTTR0202a.mov.deint.mpeg',
    'MCTTR0203a' => ' MCTTR0203a.mov.deint.mpeg',
    'MCTTR0204a' => ' MCTTR0204a.mov.deint.mpeg',
    'MCTTR0205a' => ' MCTTR0205a.mov.deint.mpeg',
    'MCTTR0201b' => ' MCTTR0201b.mov.deint.mpeg',
    'MCTTR0202b' => ' MCTTR0202b.mov.deint.mpeg',
    'MCTTR0203b' => ' MCTTR0203b.mov.deint.mpeg',
    'MCTTR0204b' => ' MCTTR0204b.mov.deint.mpeg',
    'MCTTR0205b' => ' MCTTR0205b.mov.deint.mpeg',
    'MCTTR0201c' => ' MCTTR0201c.mov.deint.mpeg',
    'MCTTR0202c' => ' MCTTR0202c.mov.deint.mpeg',
    'MCTTR0203c' => ' MCTTR0203c.mov.deint.mpeg',
    'MCTTR0204c' => ' MCTTR0204c.mov.deint.mpeg',
    'MCTTR0205c' => ' MCTTR0205c.mov.deint.mpeg',
    'MCTTR0201d' => ' MCTTR0201d.mov.deint.mpeg',
    'MCTTR0202d' => ' MCTTR0202d.mov.deint.mpeg',
    'MCTTR0203d' => ' MCTTR0203d.mov.deint.mpeg',
    'MCTTR0204d' => ' MCTTR0204d.mov.deint.mpeg',
    'MCTTR0205d' => ' MCTTR0205d.mov.deint.mpeg',
    'MCTTR0201e' => ' MCTTR0201e.mov.deint.mpeg',
    'MCTTR0202e' => ' MCTTR0202e.mov.deint.mpeg',
    'MCTTR0203e' => ' MCTTR0203e.mov.deint.mpeg',
    'MCTTR0204e' => ' MCTTR0204e.mov.deint.mpeg',
    'MCTTR0205e' => ' MCTTR0205e.mov.deint.mpeg',
    'MCTTR0201f' => ' MCTTR0201f.mov.deint.mpeg',
    'MCTTR0202f' => ' MCTTR0202f.mov.deint.mpeg',
    'MCTTR0203f' => ' MCTTR0203f.mov.deint.mpeg',
    'MCTTR0204f' => ' MCTTR0204f.mov.deint.mpeg',
    'MCTTR0205f' => ' MCTTR0205f.mov.deint.mpeg',
    'MCTTR0201g' => ' MCTTR0201g.mov.deint.mpeg',
    'MCTTR0202g' => ' MCTTR0202g.mov.deint.mpeg',
    'MCTTR0203g' => ' MCTTR0203g.mov.deint.mpeg',
    'MCTTR0204g' => ' MCTTR0204g.mov.deint.mpeg',
    'MCTTR0205g' => ' MCTTR0205g.mov.deint.mpeg',
    'MCTTR0201h' => ' MCTTR0201h.mov.deint.mpeg',
    'MCTTR0202h' => ' MCTTR0202h.mov.deint.mpeg',
    'MCTTR0203h' => ' MCTTR0203h.mov.deint.mpeg',
    'MCTTR0204h' => ' MCTTR0204h.mov.deint.mpeg',
    'MCTTR0205h' => ' MCTTR0205h.mov.deint.mpeg',
    'MCTTR0201i' => ' MCTTR0201i.mov.deint.mpeg',
    'MCTTR0202i' => ' MCTTR0202i.mov.deint.mpeg',
    'MCTTR0203i' => ' MCTTR0203i.mov.deint.mpeg',
    'MCTTR0204i' => ' MCTTR0204i.mov.deint.mpeg',
    'MCTTR0205i' => ' MCTTR0205i.mov.deint.mpeg',
    'MCTTR0201j' => ' MCTTR0201j.mov.deint.mpeg',
    'MCTTR0202j' => ' MCTTR0202j.mov.deint.mpeg',
    'MCTTR0203j' => ' MCTTR0203j.mov.deint.mpeg',
    'MCTTR0204j' => ' MCTTR0204j.mov.deint.mpeg',
    'MCTTR0205j' => ' MCTTR0205j.mov.deint.mpeg',
    'MCTTR0301a' => ' MCTTR0301a.mov.deint.mpeg',
    'MCTTR0302a' => ' MCTTR0302a.mov.deint.mpeg',
    'MCTTR0303a' => ' MCTTR0303a.mov.deint.mpeg',
    'MCTTR0304a' => ' MCTTR0304a.mov.deint.mpeg',
    'MCTTR0305a' => ' MCTTR0305a.mov.deint.mpeg',
    'MCTTR0301b' => ' MCTTR0301b.mov.deint.mpeg',
    'MCTTR0302b' => ' MCTTR0302b.mov.deint.mpeg',
    'MCTTR0303b' => ' MCTTR0303b.mov.deint.mpeg',
    'MCTTR0304b' => ' MCTTR0304b.mov.deint.mpeg',
    'MCTTR0305b' => ' MCTTR0305b.mov.deint.mpeg',
    'MCTTR0301c' => ' MCTTR0301c.mov.deint.mpeg',
    'MCTTR0302c' => ' MCTTR0302c.mov.deint.mpeg',
    'MCTTR0303c' => ' MCTTR0303c.mov.deint.mpeg',
    'MCTTR0304c' => ' MCTTR0304c.mov.deint.mpeg',
    'MCTTR0305c' => ' MCTTR0305c.mov.deint.mpeg',
    'MCTTR0301d' => ' MCTTR0301d.mov.deint.mpeg',
    'MCTTR0302d' => ' MCTTR0302d.mov.deint.mpeg',
    'MCTTR0303d' => ' MCTTR0303d.mov.deint.mpeg',
    'MCTTR0304d' => ' MCTTR0304d.mov.deint.mpeg',
    'MCTTR0305d' => ' MCTTR0305d.mov.deint.mpeg',
    'MCTTR0301e' => ' MCTTR0301e.mov.deint.mpeg',
    'MCTTR0302e' => ' MCTTR0302e.mov.deint.mpeg',
    'MCTTR0303e' => ' MCTTR0303e.mov.deint.mpeg',
    'MCTTR0304e' => ' MCTTR0304e.mov.deint.mpeg',
    'MCTTR0305e' => ' MCTTR0305e.mov.deint.mpeg',
    'MCTTR0301f' => ' MCTTR0301f.mov.deint.mpeg',
    'MCTTR0302f' => ' MCTTR0302f.mov.deint.mpeg',
    'MCTTR0303f' => ' MCTTR0303f.mov.deint.mpeg',
    'MCTTR0304f' => ' MCTTR0304f.mov.deint.mpeg',
    'MCTTR0305f' => ' MCTTR0305f.mov.deint.mpeg',
    'MCTTR0301g' => ' MCTTR0301g.mov.deint.mpeg',
    'MCTTR0302g' => ' MCTTR0302g.mov.deint.mpeg',
    'MCTTR0303g' => ' MCTTR0303g.mov.deint.mpeg',
    'MCTTR0304g' => ' MCTTR0304g.mov.deint.mpeg',
    'MCTTR0305g' => ' MCTTR0305g.mov.deint.mpeg',
    'MCTTR0301h' => ' MCTTR0301h.mov.deint.mpeg',
    'MCTTR0302h' => ' MCTTR0302h.mov.deint.mpeg',
    'MCTTR0303h' => ' MCTTR0303h.mov.deint.mpeg',
    'MCTTR0304h' => ' MCTTR0304h.mov.deint.mpeg',
    'MCTTR0305h' => ' MCTTR0305h.mov.deint.mpeg',
    'MCTTR0301i' => ' MCTTR0301i.mov.deint.mpeg',
    'MCTTR0302i' => ' MCTTR0302i.mov.deint.mpeg',
    'MCTTR0303i' => ' MCTTR0303i.mov.deint.mpeg',
    'MCTTR0304i' => ' MCTTR0304i.mov.deint.mpeg',
    'MCTTR0305i' => ' MCTTR0305i.mov.deint.mpeg',
    'MCTTR0301j' => ' MCTTR0301j.mov.deint.mpeg',
    'MCTTR0302j' => ' MCTTR0302j.mov.deint.mpeg',
    'MCTTR0303j' => ' MCTTR0303j.mov.deint.mpeg',
    'MCTTR0304j' => ' MCTTR0304j.mov.deint.mpeg',
    'MCTTR0305j' => ' MCTTR0305j.mov.deint.mpeg',
    'MCTTR0401a' => ' MCTTR0401a.mov.deint.mpeg',
    'MCTTR0402a' => ' MCTTR0402a.mov.deint.mpeg',
    'MCTTR0403a' => ' MCTTR0403a.mov.deint.mpeg',
    'MCTTR0404a' => ' MCTTR0404a.mov.deint.mpeg',
    'MCTTR0405a' => ' MCTTR0405a.mov.deint.mpeg',
    'MCTTR0401b' => ' MCTTR0401b.mov.deint.mpeg',
    'MCTTR0402b' => ' MCTTR0402b.mov.deint.mpeg',
    'MCTTR0403b' => ' MCTTR0403b.mov.deint.mpeg',
    'MCTTR0404b' => ' MCTTR0404b.mov.deint.mpeg',
    'MCTTR0405b' => ' MCTTR0405b.mov.deint.mpeg',
    'MCTTR0401c' => ' MCTTR0401c.mov.deint.mpeg',
    'MCTTR0402c' => ' MCTTR0402c.mov.deint.mpeg',
    'MCTTR0403c' => ' MCTTR0403c.mov.deint.mpeg',
    'MCTTR0404c' => ' MCTTR0404c.mov.deint.mpeg',
    'MCTTR0405c' => ' MCTTR0405c.mov.deint.mpeg',
    'MCTTR0401d' => ' MCTTR0401d.mov.deint.mpeg',
    'MCTTR0402d' => ' MCTTR0402d.mov.deint.mpeg',
    'MCTTR0403d' => ' MCTTR0403d.mov.deint.mpeg',
    'MCTTR0404d' => ' MCTTR0404d.mov.deint.mpeg',
    'MCTTR0405d' => ' MCTTR0405d.mov.deint.mpeg',
    'MCTTR0401e' => ' MCTTR0401e.mov.deint.mpeg',
    'MCTTR0402e' => ' MCTTR0402e.mov.deint.mpeg',
    'MCTTR0403e' => ' MCTTR0403e.mov.deint.mpeg',
    'MCTTR0404e' => ' MCTTR0404e.mov.deint.mpeg',
    'MCTTR0405e' => ' MCTTR0405e.mov.deint.mpeg',
    'MCTTR0401f' => ' MCTTR0401f.mov.deint.mpeg',
    'MCTTR0402f' => ' MCTTR0402f.mov.deint.mpeg',
    'MCTTR0403f' => ' MCTTR0403f.mov.deint.mpeg',
    'MCTTR0404f' => ' MCTTR0404f.mov.deint.mpeg',
    'MCTTR0405f' => ' MCTTR0405f.mov.deint.mpeg',
    'MCTTR0401g' => ' MCTTR0401g.mov.deint.mpeg',
    'MCTTR0402g' => ' MCTTR0402g.mov.deint.mpeg',
    'MCTTR0403g' => ' MCTTR0403g.mov.deint.mpeg',
    'MCTTR0404g' => ' MCTTR0404g.mov.deint.mpeg',
    'MCTTR0405g' => ' MCTTR0405g.mov.deint.mpeg',
    'MCTTR0401h' => ' MCTTR0401h.mov.deint.mpeg',
    'MCTTR0402h' => ' MCTTR0402h.mov.deint.mpeg',
    'MCTTR0403h' => ' MCTTR0403h.mov.deint.mpeg',
    'MCTTR0404h' => ' MCTTR0404h.mov.deint.mpeg',
    'MCTTR0405h' => ' MCTTR0405h.mov.deint.mpeg',
    'MCTTR0401i' => ' MCTTR0401i.mov.deint.mpeg',
    'MCTTR0402i' => ' MCTTR0402i.mov.deint.mpeg',
    'MCTTR0403i' => ' MCTTR0403i.mov.deint.mpeg',
    'MCTTR0404i' => ' MCTTR0404i.mov.deint.mpeg',
    'MCTTR0405i' => ' MCTTR0405i.mov.deint.mpeg',
    'MCTTR0401j' => ' MCTTR0401j.mov.deint.mpeg',
    'MCTTR0402j' => ' MCTTR0402j.mov.deint.mpeg',
    'MCTTR0403j' => ' MCTTR0403j.mov.deint.mpeg',
    'MCTTR0404j' => ' MCTTR0404j.mov.deint.mpeg',
    'MCTTR0405j' => ' MCTTR0405j.mov.deint.mpeg',
    'MCTTR0501a' => ' MCTTR0501a.mov.deint.mpeg',
    'MCTTR0502a' => ' MCTTR0502a.mov.deint.mpeg',
    'MCTTR0503a' => ' MCTTR0503a.mov.deint.mpeg',
    'MCTTR0504a' => ' MCTTR0504a.mov.deint.mpeg',
    'MCTTR0505a' => ' MCTTR0505a.mov.deint.mpeg',
    'MCTTR0501b' => ' MCTTR0501b.mov.deint.mpeg',
    'MCTTR0502b' => ' MCTTR0502b.mov.deint.mpeg',
    'MCTTR0503b' => ' MCTTR0503b.mov.deint.mpeg',
    'MCTTR0504b' => ' MCTTR0504b.mov.deint.mpeg',
    'MCTTR0505b' => ' MCTTR0505b.mov.deint.mpeg',
    'MCTTR0501c' => ' MCTTR0501c.mov.deint.mpeg',
    'MCTTR0502c' => ' MCTTR0502c.mov.deint.mpeg',
    'MCTTR0503c' => ' MCTTR0503c.mov.deint.mpeg',
    'MCTTR0504c' => ' MCTTR0504c.mov.deint.mpeg',
    'MCTTR0505c' => ' MCTTR0505c.mov.deint.mpeg',
    'MCTTR0501d' => ' MCTTR0501d.mov.deint.mpeg',
    'MCTTR0502d' => ' MCTTR0502d.mov.deint.mpeg',
    'MCTTR0503d' => ' MCTTR0503d.mov.deint.mpeg',
    'MCTTR0504d' => ' MCTTR0504d.mov.deint.mpeg',
    'MCTTR0505d' => ' MCTTR0505d.mov.deint.mpeg',
    'MCTTR0501e' => ' MCTTR0501e.mov.deint.mpeg',
    'MCTTR0502e' => ' MCTTR0502e.mov.deint.mpeg',
    'MCTTR0503e' => ' MCTTR0503e.mov.deint.mpeg',
    'MCTTR0504e' => ' MCTTR0504e.mov.deint.mpeg',
    'MCTTR0505e' => ' MCTTR0505e.mov.deint.mpeg',
    'MCTTR0501f' => ' MCTTR0501f.mov.deint.mpeg',
    'MCTTR0502f' => ' MCTTR0502f.mov.deint.mpeg',
    'MCTTR0503f' => ' MCTTR0503f.mov.deint.mpeg',
    'MCTTR0504f' => ' MCTTR0504f.mov.deint.mpeg',
    'MCTTR0505f' => ' MCTTR0505f.mov.deint.mpeg',
    'MCTTR0501g' => ' MCTTR0501g.mov.deint.mpeg',
    'MCTTR0502g' => ' MCTTR0502g.mov.deint.mpeg',
    'MCTTR0503g' => ' MCTTR0503g.mov.deint.mpeg',
    'MCTTR0504g' => ' MCTTR0504g.mov.deint.mpeg',
    'MCTTR0505g' => ' MCTTR0505g.mov.deint.mpeg',
    'MCTTR0601a' => ' MCTTR0601a.mov.deint.mpeg',
    'MCTTR0602a' => ' MCTTR0602a.mov.deint.mpeg',
    'MCTTR0603a' => ' MCTTR0603a.mov.deint.mpeg',
    'MCTTR0604a' => ' MCTTR0604a.mov.deint.mpeg',
    'MCTTR0605a' => ' MCTTR0605a.mov.deint.mpeg',
    'MCTTR0601b' => ' MCTTR0601b.mov.deint.mpeg',
    'MCTTR0602b' => ' MCTTR0602b.mov.deint.mpeg',
    'MCTTR0603b' => ' MCTTR0603b.mov.deint.mpeg',
    'MCTTR0604b' => ' MCTTR0604b.mov.deint.mpeg',
    'MCTTR0605b' => ' MCTTR0605b.mov.deint.mpeg',
    'MCTTR0601c' => ' MCTTR0601c.mov.deint.mpeg',
    'MCTTR0602c' => ' MCTTR0602c.mov.deint.mpeg',
    'MCTTR0603c' => ' MCTTR0603c.mov.deint.mpeg',
    'MCTTR0604c' => ' MCTTR0604c.mov.deint.mpeg',
    'MCTTR0605c' => ' MCTTR0605c.mov.deint.mpeg',
    'MCTTR0601d' => ' MCTTR0601d.mov.deint.mpeg',
    'MCTTR0602d' => ' MCTTR0602d.mov.deint.mpeg',
    'MCTTR0603d' => ' MCTTR0603d.mov.deint.mpeg',
    'MCTTR0604d' => ' MCTTR0604d.mov.deint.mpeg',
    'MCTTR0605d' => ' MCTTR0605d.mov.deint.mpeg',
    'MCTTR0601e' => ' MCTTR0601e.mov.deint.mpeg',
    'MCTTR0602e' => ' MCTTR0602e.mov.deint.mpeg',
    'MCTTR0603e' => ' MCTTR0603e.mov.deint.mpeg',
    'MCTTR0604e' => ' MCTTR0604e.mov.deint.mpeg',
    'MCTTR0605e' => ' MCTTR0605e.mov.deint.mpeg',
    'MCTTR0601f' => ' MCTTR0601f.mov.deint.mpeg',
    'MCTTR0602f' => ' MCTTR0602f.mov.deint.mpeg',
    'MCTTR0603f' => ' MCTTR0603f.mov.deint.mpeg',
    'MCTTR0604f' => ' MCTTR0604f.mov.deint.mpeg',
    'MCTTR0605f' => ' MCTTR0605f.mov.deint.mpeg',
    'MCTTR0601g' => ' MCTTR0601g.mov.deint.mpeg',
    'MCTTR0602g' => ' MCTTR0602g.mov.deint.mpeg',
    'MCTTR0603g' => ' MCTTR0603g.mov.deint.mpeg',
    'MCTTR0604g' => ' MCTTR0604g.mov.deint.mpeg',
    'MCTTR0605g' => ' MCTTR0605g.mov.deint.mpeg',
    'MCTTR0601h' => ' MCTTR0601h.mov.deint.mpeg',
    'MCTTR0602h' => ' MCTTR0602h.mov.deint.mpeg',
    'MCTTR0603h' => ' MCTTR0603h.mov.deint.mpeg',
    'MCTTR0604h' => ' MCTTR0604h.mov.deint.mpeg',
    'MCTTR0605h' => ' MCTTR0605h.mov.deint.mpeg',
    'MCTTR0601i' => ' MCTTR0601i.mov.deint.mpeg',
    'MCTTR0602i' => ' MCTTR0602i.mov.deint.mpeg',
    'MCTTR0603i' => ' MCTTR0603i.mov.deint.mpeg',
    'MCTTR0604i' => ' MCTTR0604i.mov.deint.mpeg',
    'MCTTR0605i' => ' MCTTR0605i.mov.deint.mpeg',
    'MCTTR0701a' => ' MCTTR0701a.mov.deint.mpeg',
    'MCTTR0702a' => ' MCTTR0702a.mov.deint.mpeg',
    'MCTTR0703a' => ' MCTTR0703a.mov.deint.mpeg',
    'MCTTR0704a' => ' MCTTR0704a.mov.deint.mpeg',
    'MCTTR0705a' => ' MCTTR0705a.mov.deint.mpeg',
    'MCTTR0701b' => ' MCTTR0701b.mov.deint.mpeg',
    'MCTTR0702b' => ' MCTTR0702b.mov.deint.mpeg',
    'MCTTR0703b' => ' MCTTR0703b.mov.deint.mpeg',
    'MCTTR0704b' => ' MCTTR0704b.mov.deint.mpeg',
    'MCTTR0705b' => ' MCTTR0705b.mov.deint.mpeg',
    'MCTTR0701c' => ' MCTTR0701c.mov.deint.mpeg',
    'MCTTR0702c' => ' MCTTR0702c.mov.deint.mpeg',
    'MCTTR0703c' => ' MCTTR0703c.mov.deint.mpeg',
    'MCTTR0704c' => ' MCTTR0704c.mov.deint.mpeg',
    'MCTTR0705c' => ' MCTTR0705c.mov.deint.mpeg',
    'MCTTR0701d' => ' MCTTR0701d.mov.deint.mpeg',
    'MCTTR0702d' => ' MCTTR0702d.mov.deint.mpeg',
    'MCTTR0703d' => ' MCTTR0703d.mov.deint.mpeg',
    'MCTTR0704d' => ' MCTTR0704d.mov.deint.mpeg',
    'MCTTR0705d' => ' MCTTR0705d.mov.deint.mpeg',
    'MCTTR0701e' => ' MCTTR0701e.mov.deint.mpeg',
    'MCTTR0702e' => ' MCTTR0702e.mov.deint.mpeg',
    'MCTTR0703e' => ' MCTTR0703e.mov.deint.mpeg',
    'MCTTR0704e' => ' MCTTR0704e.mov.deint.mpeg',
    'MCTTR0705e' => ' MCTTR0705e.mov.deint.mpeg',
    'MCTTR0701f' => ' MCTTR0701f.mov.deint.mpeg',
    'MCTTR0702f' => ' MCTTR0702f.mov.deint.mpeg',
    'MCTTR0703f' => ' MCTTR0703f.mov.deint.mpeg',
    'MCTTR0704f' => ' MCTTR0704f.mov.deint.mpeg',
    'MCTTR0705f' => ' MCTTR0705f.mov.deint.mpeg',
    'MCTTR0701g' => ' MCTTR0701g.mov.deint.mpeg',
    'MCTTR0702g' => ' MCTTR0702g.mov.deint.mpeg',
    'MCTTR0703g' => ' MCTTR0703g.mov.deint.mpeg',
    'MCTTR0704g' => ' MCTTR0704g.mov.deint.mpeg',
    'MCTTR0705g' => ' MCTTR0705g.mov.deint.mpeg',
    'MCTTR0801a' => ' MCTTR0801a.mov.deint.mpeg',
    'MCTTR0802a' => ' MCTTR0802a.mov.deint.mpeg',
    'MCTTR0803a' => ' MCTTR0803a.mov.deint.mpeg',
    'MCTTR0804a' => ' MCTTR0804a.mov.deint.mpeg',
    'MCTTR0805a' => ' MCTTR0805a.mov.deint.mpeg',
    'MCTTR0801b' => ' MCTTR0801b.mov.deint.mpeg',
    'MCTTR0802b' => ' MCTTR0802b.mov.deint.mpeg',
    'MCTTR0803b' => ' MCTTR0803b.mov.deint.mpeg',
    'MCTTR0804b' => ' MCTTR0804b.mov.deint.mpeg',
    'MCTTR0805b' => ' MCTTR0805b.mov.deint.mpeg',
    'MCTTR0801c' => ' MCTTR0801c.mov.deint.mpeg',
    'MCTTR0802c' => ' MCTTR0802c.mov.deint.mpeg',
    'MCTTR0803c' => ' MCTTR0803c.mov.deint.mpeg',
    'MCTTR0804c' => ' MCTTR0804c.mov.deint.mpeg',
    'MCTTR0805c' => ' MCTTR0805c.mov.deint.mpeg',
    'MCTTR0801d' => ' MCTTR0801d.mov.deint.mpeg',
    'MCTTR0802d' => ' MCTTR0802d.mov.deint.mpeg',
    'MCTTR0803d' => ' MCTTR0803d.mov.deint.mpeg',
    'MCTTR0804d' => ' MCTTR0804d.mov.deint.mpeg',
    'MCTTR0805d' => ' MCTTR0805d.mov.deint.mpeg',
    'MCTTR0801e' => ' MCTTR0801e.mov.deint.mpeg',
    'MCTTR0802e' => ' MCTTR0802e.mov.deint.mpeg',
    'MCTTR0803e' => ' MCTTR0803e.mov.deint.mpeg',
    'MCTTR0804e' => ' MCTTR0804e.mov.deint.mpeg',
    'MCTTR0805e' => ' MCTTR0805e.mov.deint.mpeg',
    'MCTTR0801f' => ' MCTTR0801f.mov.deint.mpeg',
    'MCTTR0802f' => ' MCTTR0802f.mov.deint.mpeg',
    'MCTTR0803f' => ' MCTTR0803f.mov.deint.mpeg',
    'MCTTR0804f' => ' MCTTR0804f.mov.deint.mpeg',
    'MCTTR0805f' => ' MCTTR0805f.mov.deint.mpeg',
    'MCTTR0801g' => ' MCTTR0801g.mov.deint.mpeg',
    'MCTTR0802g' => ' MCTTR0802g.mov.deint.mpeg',
    'MCTTR0803g' => ' MCTTR0803g.mov.deint.mpeg',
    'MCTTR0804g' => ' MCTTR0804g.mov.deint.mpeg',
    'MCTTR0805g' => ' MCTTR0805g.mov.deint.mpeg',
    'MCTTR0801h' => ' MCTTR0801h.mov.deint.mpeg',
    'MCTTR0802h' => ' MCTTR0802h.mov.deint.mpeg',
    'MCTTR0803h' => ' MCTTR0803h.mov.deint.mpeg',
    'MCTTR0804h' => ' MCTTR0804h.mov.deint.mpeg',
    'MCTTR0805h' => ' MCTTR0805h.mov.deint.mpeg',
    'MCTTR0801i' => ' MCTTR0801i.mov.deint.mpeg',
    'MCTTR0802i' => ' MCTTR0802i.mov.deint.mpeg',
    'MCTTR0803i' => ' MCTTR0803i.mov.deint.mpeg',
    'MCTTR0804i' => ' MCTTR0804i.mov.deint.mpeg',
    'MCTTR0805i' => ' MCTTR0805i.mov.deint.mpeg',
    'MCTTR0801j' => ' MCTTR0801j.mov.deint.mpeg',
    'MCTTR0802j' => ' MCTTR0802j.mov.deint.mpeg',
    'MCTTR0803j' => ' MCTTR0803j.mov.deint.mpeg',
    'MCTTR0804j' => ' MCTTR0804j.mov.deint.mpeg',
    'MCTTR0805j' => ' MCTTR0805j.mov.deint.mpeg',
    'MCTTR0901a' => ' MCTTR0901a.mov.deint.mpeg',
    'MCTTR0902a' => ' MCTTR0902a.mov.deint.mpeg',
    'MCTTR0903a' => ' MCTTR0903a.mov.deint.mpeg',
    'MCTTR0904a' => ' MCTTR0904a.mov.deint.mpeg',
    'MCTTR0905a' => ' MCTTR0905a.mov.deint.mpeg',
    'MCTTR0901b' => ' MCTTR0901b.mov.deint.mpeg',
    'MCTTR0902b' => ' MCTTR0902b.mov.deint.mpeg',
    'MCTTR0903b' => ' MCTTR0903b.mov.deint.mpeg',
    'MCTTR0904b' => ' MCTTR0904b.mov.deint.mpeg',
    'MCTTR0905b' => ' MCTTR0905b.mov.deint.mpeg',
    'MCTTR0901c' => ' MCTTR0901c.mov.deint.mpeg',
    'MCTTR0902c' => ' MCTTR0902c.mov.deint.mpeg',
    'MCTTR0903c' => ' MCTTR0903c.mov.deint.mpeg',
    'MCTTR0904c' => ' MCTTR0904c.mov.deint.mpeg',
    'MCTTR0905c' => ' MCTTR0905c.mov.deint.mpeg',
    'MCTTR0901d' => ' MCTTR0901d.mov.deint.mpeg',
    'MCTTR0902d' => ' MCTTR0902d.mov.deint.mpeg',
    'MCTTR0903d' => ' MCTTR0903d.mov.deint.mpeg',
    'MCTTR0904d' => ' MCTTR0904d.mov.deint.mpeg',
    'MCTTR0905d' => ' MCTTR0905d.mov.deint.mpeg',
    'MCTTR0901e' => ' MCTTR0901e.mov.deint.mpeg',
    'MCTTR0902e' => ' MCTTR0902e.mov.deint.mpeg',
    'MCTTR0903e' => ' MCTTR0903e.mov.deint.mpeg',
    'MCTTR0904e' => ' MCTTR0904e.mov.deint.mpeg',
    'MCTTR0905e' => ' MCTTR0905e.mov.deint.mpeg',
    'MCTTR0901f' => ' MCTTR0901f.mov.deint.mpeg',
    'MCTTR0902f' => ' MCTTR0902f.mov.deint.mpeg',
    'MCTTR0903f' => ' MCTTR0903f.mov.deint.mpeg',
    'MCTTR0904f' => ' MCTTR0904f.mov.deint.mpeg',
    'MCTTR0905f' => ' MCTTR0905f.mov.deint.mpeg',
    'MCTTR0901g' => ' MCTTR0901g.mov.deint.mpeg',
    'MCTTR0902g' => ' MCTTR0902g.mov.deint.mpeg',
    'MCTTR0903g' => ' MCTTR0903g.mov.deint.mpeg',
    'MCTTR0904g' => ' MCTTR0904g.mov.deint.mpeg',
    'MCTTR0905g' => ' MCTTR0905g.mov.deint.mpeg',
    'MCTTR0901h' => ' MCTTR0901h.mov.deint.mpeg',
    'MCTTR0902h' => ' MCTTR0902h.mov.deint.mpeg',
    'MCTTR0903h' => ' MCTTR0903h.mov.deint.mpeg',
    'MCTTR0904h' => ' MCTTR0904h.mov.deint.mpeg',
    'MCTTR0905h' => ' MCTTR0905h.mov.deint.mpeg',
    'MCTTR0901i' => ' MCTTR0901i.mov.deint.mpeg',
    'MCTTR0902i' => ' MCTTR0902i.mov.deint.mpeg',
    'MCTTR0903i' => ' MCTTR0903i.mov.deint.mpeg',
    'MCTTR0904i' => ' MCTTR0904i.mov.deint.mpeg',
    'MCTTR0905i' => ' MCTTR0905i.mov.deint.mpeg',
    'MCTTR0901j' => ' MCTTR0901j.mov.deint.mpeg',
    'MCTTR0902j' => ' MCTTR0902j.mov.deint.mpeg',
    'MCTTR0903j' => ' MCTTR0903j.mov.deint.mpeg',
    'MCTTR0904j' => ' MCTTR0904j.mov.deint.mpeg',
    'MCTTR0905j' => ' MCTTR0905j.mov.deint.mpeg',
    'MCTTR1001a' => ' MCTTR1001a.mov.deint.mpeg',
    'MCTTR1002a' => ' MCTTR1002a.mov.deint.mpeg',
    'MCTTR1003a' => ' MCTTR1003a.mov.deint.mpeg',
    'MCTTR1004a' => ' MCTTR1004a.mov.deint.mpeg',
    'MCTTR1005a' => ' MCTTR1005a.mov.deint.mpeg',
    'MCTTR1001b' => ' MCTTR1001b.mov.deint.mpeg',
    'MCTTR1002b' => ' MCTTR1002b.mov.deint.mpeg',
    'MCTTR1003b' => ' MCTTR1003b.mov.deint.mpeg',
    'MCTTR1004b' => ' MCTTR1004b.mov.deint.mpeg',
    'MCTTR1005b' => ' MCTTR1005b.mov.deint.mpeg',
    'MCTTR1001c' => ' MCTTR1001c.mov.deint.mpeg',
    'MCTTR1002c' => ' MCTTR1002c.mov.deint.mpeg',
    'MCTTR1003c' => ' MCTTR1003c.mov.deint.mpeg',
    'MCTTR1004c' => ' MCTTR1004c.mov.deint.mpeg',
    'MCTTR1005c' => ' MCTTR1005c.mov.deint.mpeg',
    'MCTTR1001d' => ' MCTTR1001d.mov.deint.mpeg',
    'MCTTR1002d' => ' MCTTR1002d.mov.deint.mpeg',
    'MCTTR1003d' => ' MCTTR1003d.mov.deint.mpeg',
    'MCTTR1004d' => ' MCTTR1004d.mov.deint.mpeg',
    'MCTTR1005d' => ' MCTTR1005d.mov.deint.mpeg',
    'MCTTR1001e' => ' MCTTR1001e.mov.deint.mpeg',
    'MCTTR1002e' => ' MCTTR1002e.mov.deint.mpeg',
    'MCTTR1003e' => ' MCTTR1003e.mov.deint.mpeg',
    'MCTTR1004e' => ' MCTTR1004e.mov.deint.mpeg',
    'MCTTR1005e' => ' MCTTR1005e.mov.deint.mpeg',
    'MCTTR1001f' => ' MCTTR1001f.mov.deint.mpeg',
    'MCTTR1002f' => ' MCTTR1002f.mov.deint.mpeg',
    'MCTTR1003f' => ' MCTTR1003f.mov.deint.mpeg',
    'MCTTR1004f' => ' MCTTR1004f.mov.deint.mpeg',
    'MCTTR1005f' => ' MCTTR1005f.mov.deint.mpeg',
    'MCTTR1001g' => ' MCTTR1001g.mov.deint.mpeg',
    'MCTTR1002g' => ' MCTTR1002g.mov.deint.mpeg',
    'MCTTR1003g' => ' MCTTR1003g.mov.deint.mpeg',
    'MCTTR1004g' => ' MCTTR1004g.mov.deint.mpeg',
    'MCTTR1005g' => ' MCTTR1005g.mov.deint.mpeg',
    'MCTTR1001h' => ' MCTTR1001h.mov.deint.mpeg',
    'MCTTR1002h' => ' MCTTR1002h.mov.deint.mpeg',
    'MCTTR1003h' => ' MCTTR1003h.mov.deint.mpeg',
    'MCTTR1004h' => ' MCTTR1004h.mov.deint.mpeg',
    'MCTTR1005h' => ' MCTTR1005h.mov.deint.mpeg',
    'MCTTR1001i' => ' MCTTR1001i.mov.deint.mpeg',
    'MCTTR1002i' => ' MCTTR1002i.mov.deint.mpeg',
    'MCTTR1003i' => ' MCTTR1003i.mov.deint.mpeg',
    'MCTTR1004i' => ' MCTTR1004i.mov.deint.mpeg',
    'MCTTR1005i' => ' MCTTR1005i.mov.deint.mpeg',
    'MCTTR1101a' => ' MCTTR1101a.mov.deint.mpeg',
    'MCTTR1102a' => ' MCTTR1102a.mov.deint.mpeg',
    'MCTTR1103a' => ' MCTTR1103a.mov.deint.mpeg',
    'MCTTR1104a' => ' MCTTR1104a.mov.deint.mpeg',
    'MCTTR1105a' => ' MCTTR1105a.mov.deint.mpeg',
    'MCTTR1101b' => ' MCTTR1101b.mov.deint.mpeg',
    'MCTTR1102b' => ' MCTTR1102b.mov.deint.mpeg',
    'MCTTR1103b' => ' MCTTR1103b.mov.deint.mpeg',
    'MCTTR1104b' => ' MCTTR1104b.mov.deint.mpeg',
    'MCTTR1105b' => ' MCTTR1105b.mov.deint.mpeg',
    'MCTTR1101c' => ' MCTTR1101c.mov.deint.mpeg',
    'MCTTR1102c' => ' MCTTR1102c.mov.deint.mpeg',
    'MCTTR1103c' => ' MCTTR1103c.mov.deint.mpeg',
    'MCTTR1104c' => ' MCTTR1104c.mov.deint.mpeg',
    'MCTTR1105c' => ' MCTTR1105c.mov.deint.mpeg',
    'MCTTR1101d' => ' MCTTR1101d.mov.deint.mpeg',
    'MCTTR1102d' => ' MCTTR1102d.mov.deint.mpeg',
    'MCTTR1103d' => ' MCTTR1103d.mov.deint.mpeg',
    'MCTTR1104d' => ' MCTTR1104d.mov.deint.mpeg',
    'MCTTR1105d' => ' MCTTR1105d.mov.deint.mpeg',
    'MCTTR1101e' => ' MCTTR1101e.mov.deint.mpeg',
    'MCTTR1102e' => ' MCTTR1102e.mov.deint.mpeg',
    'MCTTR1103e' => ' MCTTR1103e.mov.deint.mpeg',
    'MCTTR1104e' => ' MCTTR1104e.mov.deint.mpeg',
    'MCTTR1105e' => ' MCTTR1105e.mov.deint.mpeg',
    'MCTTR1101f' => ' MCTTR1101f.mov.deint.mpeg',
    'MCTTR1102f' => ' MCTTR1102f.mov.deint.mpeg',
    'MCTTR1103f' => ' MCTTR1103f.mov.deint.mpeg',
    'MCTTR1104f' => ' MCTTR1104f.mov.deint.mpeg',
    'MCTTR1105f' => ' MCTTR1105f.mov.deint.mpeg',
    'MCTTR1101g' => ' MCTTR1101g.mov.deint.mpeg',
    'MCTTR1102g' => ' MCTTR1102g.mov.deint.mpeg',
    'MCTTR1103g' => ' MCTTR1103g.mov.deint.mpeg',
    'MCTTR1104g' => ' MCTTR1104g.mov.deint.mpeg',
    'MCTTR1105g' => ' MCTTR1105g.mov.deint.mpeg',
    'MCTTR1101h' => ' MCTTR1101h.mov.deint.mpeg',
    'MCTTR1102h' => ' MCTTR1102h.mov.deint.mpeg',
    'MCTTR1103h' => ' MCTTR1103h.mov.deint.mpeg',
    'MCTTR1104h' => ' MCTTR1104h.mov.deint.mpeg',
    'MCTTR1105h' => ' MCTTR1105h.mov.deint.mpeg',
    'MCTTR1101i' => ' MCTTR1101i.mov.deint.mpeg',
    'MCTTR1102i' => ' MCTTR1102i.mov.deint.mpeg',
    'MCTTR1103i' => ' MCTTR1103i.mov.deint.mpeg',
    'MCTTR1104i' => ' MCTTR1104i.mov.deint.mpeg',
    'MCTTR1105i' => ' MCTTR1105i.mov.deint.mpeg',
    'MCTTR1201a' => ' MCTTR1201a.mov.deint.mpeg',
    'MCTTR1202a' => ' MCTTR1202a.mov.deint.mpeg',
    'MCTTR1203a' => ' MCTTR1203a.mov.deint.mpeg',
    'MCTTR1204a' => ' MCTTR1204a.mov.deint.mpeg',
    'MCTTR1205a' => ' MCTTR1205a.mov.deint.mpeg',
    'MCTTR1201b' => ' MCTTR1201b.mov.deint.mpeg',
    'MCTTR1202b' => ' MCTTR1202b.mov.deint.mpeg',
    'MCTTR1203b' => ' MCTTR1203b.mov.deint.mpeg',
    'MCTTR1204b' => ' MCTTR1204b.mov.deint.mpeg',
    'MCTTR1205b' => ' MCTTR1205b.mov.deint.mpeg',
    'MCTTR1201c' => ' MCTTR1201c.mov.deint.mpeg',
    'MCTTR1202c' => ' MCTTR1202c.mov.deint.mpeg',
    'MCTTR1203c' => ' MCTTR1203c.mov.deint.mpeg',
    'MCTTR1204c' => ' MCTTR1204c.mov.deint.mpeg',
    'MCTTR1205c' => ' MCTTR1205c.mov.deint.mpeg',
    'MCTTR1201d' => ' MCTTR1201d.mov.deint.mpeg',
    'MCTTR1202d' => ' MCTTR1202d.mov.deint.mpeg',
    'MCTTR1203d' => ' MCTTR1203d.mov.deint.mpeg',
    'MCTTR1204d' => ' MCTTR1204d.mov.deint.mpeg',
    'MCTTR1205d' => ' MCTTR1205d.mov.deint.mpeg',
    'MCTTR1201e' => ' MCTTR1201e.mov.deint.mpeg',
    'MCTTR1202e' => ' MCTTR1202e.mov.deint.mpeg',
    'MCTTR1203e' => ' MCTTR1203e.mov.deint.mpeg',
    'MCTTR1204e' => ' MCTTR1204e.mov.deint.mpeg',
    'MCTTR1205e' => ' MCTTR1205e.mov.deint.mpeg',
    'MCTTR1201f' => ' MCTTR1201f.mov.deint.mpeg',
    'MCTTR1202f' => ' MCTTR1202f.mov.deint.mpeg',
    'MCTTR1203f' => ' MCTTR1203f.mov.deint.mpeg',
    'MCTTR1204f' => ' MCTTR1204f.mov.deint.mpeg',
    'MCTTR1205f' => ' MCTTR1205f.mov.deint.mpeg',
    'MCTTR1201g' => ' MCTTR1201g.mov.deint.mpeg',
    'MCTTR1202g' => ' MCTTR1202g.mov.deint.mpeg',
    'MCTTR1203g' => ' MCTTR1203g.mov.deint.mpeg',
    'MCTTR1204g' => ' MCTTR1204g.mov.deint.mpeg',
    'MCTTR1205g' => ' MCTTR1205g.mov.deint.mpeg',
   }
  );