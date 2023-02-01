#!/bin/bash
# platform = Red Hat Enterprise Linux 8,multi_platform_fedora,Oracle Linux 8,multi_platform_sle

# Check rsyslog.conf with root user log from rules and
# root user log from multiline include() passes.

source $SHARED/rsyslog_log_utils.sh

{{% if ATTRIBUTE == "owner" %}}
CHATTR="chown"
{{% else %}}
CHATTR="chgrp"
{{% endif %}}

USER=root

# setup test data
create_rsyslog_test_logs 2

# setup test log files ownership
$CHATTR $USER ${RSYSLOG_TEST_LOGS[0]}
$CHATTR $USER ${RSYSLOG_TEST_LOGS[1]}

# create test configuration file
test_conf=${RSYSLOG_TEST_DIR}/test1.conf
cat << EOF > ${test_conf}
# rsyslog configuration file

#### RULES ####

*.*     ${RSYSLOG_TEST_LOGS[1]}
EOF

# create rsyslog.conf configuration file
cat << EOF > $RSYSLOG_CONF
# rsyslog configuration file

#### RULES ####

*.*     ${RSYSLOG_TEST_LOGS[0]}

#### MODULES ####

include(
   file="${test_conf}"
)
EOF