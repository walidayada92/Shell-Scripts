

export ROM_BASE=/rg/liomr01/docfamily
export strict_users=0
export romuser=`id -un`
export ROM_ENV=`expr substr $romuser 1 2`
export ACTENV=`echo "$ROM_ENV" | tr a-z A-Z`
export JAVA_HOME=/usr/java/jdk1.7.0_79
export NLS_LANG=GERMAN_GERMANY.WE8ISO8859P1

senv()
{
	echo
	echo "	ROM xx.01 Environment Settings"
	echo "	Environment : $ROM_ENV"
	echo

	typeset arg
	typeset lst
	typeset pkg
	typeset str
	
	lst=""
        export  dir=`ls -d $ROM_BASE/$ROM_ENV/*in/PRD/pkg???$ROM_ENV/???`
 
        while read str
	do
	        str=`echo ${str##*/}` 	
	        lst=`echo $lst $str` 
	done <<<  "$dir"

	echo "	Available   : $lst" 

	if [ $strict_users -eq 1 ]
	then
		arg=`echo $LOGNAME | perl -p -e 's/^'$ROM_ENV'_//'` 
	else
		arg=`echo $1` 
	fi

	str=`perl -e 'print uc '$arg` 

	if [ -z "$str" -a -z "$ROM_STR" ]
	then
		echo
		echo "use 'senv <instance>' to select instance."
		return
	fi

	if [ -z "$str" ]
	then
		echo "	Active      : $ROM_STR"
		echo
		return
	fi

	echo "	Active      : $str"

## initalice
        export ROM_STR=$str

	export LANG=en_US.UTF-8

 	export ROM_DIR=`ls -d $ROM_BASE/$ROM_ENV/*in/PRD/pkg???$ROM_ENV/$ROM_STR`

        export ROM_HOME=$ROM_DIR
        cd $ROM_HOME 2>/dev/null

	export CATALINA_HOME=$ROM_HOME
	export CATALINA_BASE=$ROM_HOME

    case $ROM_STR in

      A01|A02|A03|A04|A05|A06|A07|A08)
	export JAVA_HOME=/usr/java/jdk1.7.0_79
	export CATALINA_OPTS="-Djava.protocol.handler.pkgs=sun.net.www.protocol -Djava.awt.headless=true"
	export JAVA_OPTS='-Xms1024m -Xmx2024m -XX:+UseBiasedLocking -XX:+AggressiveOpts -XX:+UseParallelOldGC -Xss256k'

	;;
      EA1)
	export JAVA_HOME=/usr/java/jdk1.8.0_202
	export CATALINA_OPTS="-Djavax.xml.validation.SchemaFactory:http://www.w3.org/2001/XMLSchema=org.apache.xerces.jaxp.validation.XMLSchemaFactory -Djava.protocol.handler.pkgs=sun.net.www.protocol -Djava.awt.headless=true"
	export JAVA_OPTS="-XX:PermSize=512m -Xms1024m -Xmx1024m -Xmn512m"

	;;
      OM1|OM2)
	export JAVA_HOME=/usr/java/jdk-11.0.2
	export CATALINA_OPTS='-Djava.protocol.handler.pkgs=sun.net.www.protocol -Djava.awt.headless=true -Djavax.xml.xpath.XPathFactory:http://java.sun.com/jaxp/xpath/dom=net.sf.saxon.xpath.XPathFactoryImpl'
	export JAVA_OPTS="-XX:PermSize=512m -Xms2024m -Xmx2024m -Xmn1000m"

	;;
      OR1)
	export JAVA_HOME=/usr/java/jdk1.7.0_79
	export CATALINA_OPTS="-Djava.protocol.handler.pkgs=sun.net.www.protocol -Djavax.net.ssl.trustStore=$ROM_HOME/conf/assentis.jks -DDocRepoID=$ROM_HOME -DAssentisResourcesDir=$ROM_HOME/conf -Djava.security.auth.login.config=$ROM_HOME/conf/jaas.config"
	export JAVA_OPTS='-Xmx512m'

	;;
      W01)
	export JAVA_HOME=/usr/java/jdk1.7.0_79
	export CATALINA_OPTS="-Djava.protocol.handler.pkgs=sun.net.www.protocol -Djava.awt.headless=true"
	export JAVA_OPTS='-Xms1024m -Xmx2024m -XX:+UseBiasedLocking -XX:+AggressiveOpts -XX:+UseParallelOldGC -Xss256k'

	;;

      AS1)
	export JAVA_HOME=/usr/java/jdk1.8.0_202
	export CATALINA_OPTS='-Djava.protocol.handler.pkgs=sun.net.www.protocol -Djava.awt.headless=true -Djavax.xml.xpath.XPathFactory:http://java.sun.com/jaxp/xpath/dom=net.sf.saxon.xpath.XPathFactoryImpl'
	export JAVA_OPTS="-XX:PermSize=512m -Xms2024m -Xmx2024m -Xmn1000m"

	;;

      FA1)
	export JAVA_HOME=/usr/java/jdk-11.0.2
	export CATALINA_OPTS='-Djava.protocol.handler.pkgs=sun.net.www.protocol -Djava.awt.headless=true -Djavax.xml.xpath.XPathFactory:http://java.sun.com/jaxp/xpath/dom=net.sf.saxon.xpath.XPathFactoryImpl'
	export JAVA_OPTS="-XX:PermSize=512m -Xms1024m -Xmx1024m -Xmn512m"

	;;
       
   OD1)
	export JAVA_HOME=/usr/java/jdk-11.0.2
        unset CATALINA_OPTS
        export JAVA_OPTS="-XX:PermSize=512m -Xms1024m -Xmx1024m -Xmn512m"

        ;;

   BS1)
	export JAVA_HOME=/usr/java/jdk-11.0.2
        unset CATALINA_OPTS
        export JAVA_OPTS="-XX:PermSize=512m -Xms1024m -Xmx1024m -Xmn512m"

        ;;

      *)
	 echo "Error:Undefined instance"


        ;;
    esac

	if [ $? -ne 0 ]
	then
		echo "	Active      : $ROM_STR"
		echo
		echo "\aERROR: selected instance $str not found!"
		return
	fi		

	export PS1='$LOGNAME@'$(hostname)'/$ROM_STR:$PWD$ '

	
        alias base='cd $ROM_DIR'
	alias home='cd $ROM_HOME'
	alias bin='cd $ROM_HOME/bin'
	alias etc='cd $ROM_HOME/conf'
	alias web='cd $ROM_HOME/webapps'
	alias log='cd $ROM_HOME/logs'
	alias tmp='cd $ROM_HOME/temp'
	alias wrk='cd $ROM_HOME/work'
	alias pss='ps -fu $LOGNAME | fgrep "$ROM_BASE" | fgrep -v grep'
	alias psi='ps -fu $LOGNAME | fgrep \/$ROM_STR\/ | fgrep -v grep'

	echo
	echo "Aliases:"
	echo "  base  - Application base directory"
	echo "  home  - Instance home directory"
	echo "  bin   - Instance 'bin' directory"
	echo "  etc   - Instance 'conf' directory"
	echo "  web   - Instance 'webapps' directory"
	echo "  log   - Instance 'logs' directory"
	echo "  tmp   - Instance 'temp' directory"
	echo "  wrk   - Instance 'work' directory"
	echo "  pss   - Application process list"
	echo "  psi   - Instance process list"
	echo

}

senv


