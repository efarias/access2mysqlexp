## $Id: repmind.cfg.sh,v 0.1 2010/11/14 3:19:20 efarias Exp efarias $
## vim:ts=4:sw=4:tw=200:nu:ai:nowrap:

##
## application settings
##
#README.md

export BASEDIR=/home/repmind
export DB_NAME=pesajeSER.mdb
export db=$BASEDIR/$DB_NAME
export db_ASC=$db.asc
export db_MD5=`md5sum -c $db_ASC`
export SQLDIR_OLD=$BASEDIR/values_old
export SQLDIR_ACT=$BASEDIR/values_act
export SQLDIR_NEW=$BASEDIR/values_new


