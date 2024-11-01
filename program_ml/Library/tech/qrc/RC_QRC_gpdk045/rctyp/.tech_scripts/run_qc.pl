######################################################################
#
#  CdnLglNtc    [ Copyright (c) 2002-2005
#               | Cadence Design Systems, Inc. All rights reserved.
#               |
#               | THIS PROGRAM IS CONFIDENTIAL AND PROPRIETARY
#               | TO CADENCE DESIGN SYSTEMS, INC. AND CONSTITUTES
#               | A VALUABLE TRADE SECRET.
#               |
#               | This work may not be copied, modified, re-published,
#               | uploaded, executed, or distributed in any way, in any
#               | medium, whether in whole or in part, without prior
#               | written permission from Cadence Design Systems, Inc.
#               ]
#  Synopsis     [ Convert old-style notices to new style ]
#  Description  [ Has meta knowledge of historical stuff at Simplex,
#                 such as the old CPP_EMBED_NOTICES convention.
#
#                 Requires the code was reasonably compliant with the
#                 old standard.
#               ]
########################################################################


use Getopt::Long;
GetOptions("acc:s", "time:i", "coupl:i", "exe:s", "options:s");

if (!$opt_acc) {
  $min_accuracy_pc = "1%";
}
else {
  $min_accuracy_pc = $opt_acc;
}
if (!$opt_time) {
  $max_time = 5;
}
else {
  $max_time = $opt_time;
}
if (!$opt_coupl) {
  $coupling = 0;
}
else {
  $coupling = 1;
}

if (!$opt_options) {
  $options = "";
}
else {
  $options = -$opt_options;
}

($qc_dir, $extension) = @ARGV;

if (!$opt_exe) {
  $qc_exe = "/users/simplex/sun5/bin/3.0.1/quickcap";
}
else {
  $qc_exe = $opt_exe;
}


use Cwd;
$cur_dir = cwd;

chdir($qc_dir);
@files = split('\n', `ls *.$extension`);
foreach $input (@files) {
  if ($coupling == 1) {
    `$qc_exe -matrix -g$min_accuracy_pc $min_accuracy_val -m$max_time $options $input`;
  }
  else {
    if (index($input, "2d") == -1) {
      `$qc_exe -g$min_accuracy_pc -m$max_time $options $input`;
    }
    else {
      `$qc_exe -2d -g$min_accuracy_pc -m$max_time $options $input`;
    }
  }
}
chdir($cur_dir);

