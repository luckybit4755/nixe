#!/bin/bash	

JSPANK_USAGE="usage"
JSPANK_GENERATE="generate"

JSPANK_TYPE_POJO="pojo"
JSPANK_TYPE_INTERFACE="interface"
JSPANK_TYPE_BASE="base"
JSPANK_TYPE_ENTITY="entity"
JSPANK_TYPE_MANAGED="managed"
JSPANK_TYPE_LOCAL="local"
JSPANK_TYPE_MANAGER="manager"

TYPE_IDX=0
TYPE_IDXS=""

_jspank_log() {
	local noop=0
	echo '/*'${*}'*/'
}

_jspank_first_up() {
	echo ${*} | awk '{ print toupper( substr( $1, 1, 1 ) )substr( $1, 2 ); }'
}

_jspank_first_down() {
	echo ${*} | awk '{ print tolower( substr( $1, 1, 1 ) )substr( $1, 2 ); }'
}

_jspank_is_collection() {
	echo ${*} | grep -c '<'
}

_jspank_normalize_args() {
	local result=${1} ; shift
	while [ "" != "${1}" ] ; do
		result="${result} ${1}"
		shift;
	done
	echo ${result}
}

_jspank_all_but_last_arg() {
	echo ${*} | sed 's, [^ ]*$,,'
}

_jspank_last_arg() {
	echo ${*} | sed 's,.* ,,'
}

_jspank_inner_type() {
	_jspank_last_arg $( echo ${*} | sed 's,.*<,,;s,>.*,,;' )
}

_jspank_process_line() {
	local type=""
	local name=""
	if [ 1 = ${#} ] ; then
		type=${1}
		name=$( _jspank_first_down ${type} )
	else 
		type=$( _jspank_all_but_last_arg ${*} )
		name=$( _jspank_last_arg ${*} )
	fi
	TYPES[ TYPE_IDX ]=${type}
	NAMES[ TYPE_IDX ]=${name}
	TYPE_IDXS="${TYPE_IDXS} ${TYPE_IDX}"
	let TYPE_IDX=${TYPE_IDX}+1
}

_jspank_addId() {
	local idx
	local hasId=0
	for idx in ${TYPE_IDXS} ; do 
		local name=${NAMES[${idx}]}
		if [ "id" = "${name}" ] ; then
			hasId=1
			break;
		fi
	done
	if [ 0 = ${hasId} ] ; then
		local i=1
		local q

		TMP_TYPES[ 0 ]=long
		TMP_NAMES[ 0 ]=id
		
		for q in ${TYPE_IDXS} ; do
			local type=${TYPES[${q}]}
			local name=${NAMES[${q}]}
			TMP_TYPES[${i}]=${type}
			TMP_NAMES[${i}]=${name}
			let i=${i}+1
		done
		let i=${i}-1
		TYPE_IDXS="${TYPE_IDXS} ${i}"

		for i in ${TYPE_IDXS} ; do 
			local type=${TMP_TYPES[${i}]}
			local name=${TMP_NAMES[${i}]}
			NAMES[ i ]=${name}
			TYPES[ i ]=${type}
		done

		unset TMP_TYPES
		unset TMP_NAMES
	fi
}

_jspank_accumulate_types() {
	local line
	while read line ; do 
		_jspank_process_line $( _jspank_normalize_args ${line} )
	done

	#TODO: not all types probly need to do this...

	_jspank_one_of "${_jspank_type}" ${JSPANK_TYPE_POJO}
	if [ 0 != ${?} ] ; then
		_jspank_addId
	fi
}

_jspank_generat_decl() {
	local type="${1}" ; shift
	local name="${1}" ; shift
cat << EOM
	private ${type} ${name}_;
EOM
}

_jspank_generate_gs_simple() {
	local type="${1}" ; shift
	local name="${1}" ; shift
	local upper=$( _jspank_first_up ${name} )
cat << EOM
	public ${type} get${upper}() {
		return this.${name}_;
	}

	public void set${upper}( ${type} ${name} ) {
		this.${name}_ = ${name};
	}

EOM
}

_jspank_concrete() {
	sed 's,Collection,ArrayList,;s,Map,HashMap,;s,List,ArrayList,;s,Set,HashSet,'
}

_jspank_generate_gs_new() {
	local type="${1}" ; shift
	local name="${1}" ; shift
	local upper=$( _jspank_first_up ${name} )
	local concrete=$( echo ${type} | _jspank_concrete )
cat << EOM
	public ${type} get${upper}() {
		return (
				null == this.${name}_
				? this.${name}_ = this.new${upper}()
				: this.${name}_
			   );
	}

	public ${type} new${upper}() {
		return new ${concrete}();
	}

	public void set${upper}( ${type} ${name} ) {
		this.${name}_ = ${name};
	}

EOM
}

_jspank_generate_gs() {
	local type="${1}" ; shift
	local name="${1}" ; shift
	if [ "0" = "$( _jspank_is_collection ${type} )" ] ; then
		_jspank_generate_gs_simple "${type}" "${name}"
	else
		_jspank_generate_gs_new "${type}" "${name}"
	fi
}
		
_jspank_generate_entity_gs() {
	local type="${1}" ; shift
	local name="${1}" ; shift
	local upper=$( _jspank_first_up ${name} )
	local lower=$( _jspank_first_down ${classname} )

	#ANNOTATIONS!
	if [ "id" = "${name}" ] ; then
cat << EOM
	@Id
	@GeneratedValue
EOM
	fi

	if [ "1" = "$( _jspank_is_collection ${type} )" ] ; then
cat << EOM
	// @ManyToOne
	// @JoinTable( name = "join_${lower}_${name}" )
	// @ManyToMany( fetch = FetchType.EAGER )
	@OneToMany //( mappedBy = "${name}" )
EOM
	fi

cat << EOM 
	public ${type} get${upper}() {
		return super.get${upper}();
	}

EOM
}

_jspank_generate_finders() {
	local type="${1}" ; shift
	local name="${1}" ; shift
	local upper=$( _jspank_first_up ${name} )

	type=$( _jspank_inner_type ${type} )
cat << EOM
	public List< ${classname} > find${classname}By${upper}( ${type} ${name} ) {
		return this.find${classname}( "${name}", ${name} );
	}

EOM
}

_jspank_loop() {
	local function=${1}
	local idx
	for idx in ${TYPE_IDXS} ; do 
		local type=${TYPES[${idx}]}
		local name=${NAMES[${idx}]}
		${function} "${type}" "${name}"
	done
}

_jspank_generate_constructor() {
	local classname=${1} ; shift
	local i
	local args=""
	for i in ${*} ; do
		local type=${TYPES[${i}]}
		local name=${NAMES[${i}]}
		if [ "" != "${args}" ] ; then
			args="${args}, "
		fi
		args="${args}${type} ${name}"
	done

cat << EOM
	public ${classname}( ${args} ) {
EOM
	for i in ${*} ; do
		local type=${TYPES[${i}]}
		local name=${NAMES[${i}]}
		local upper=$( _jspank_first_up ${name} )
cat << EOM 
		this.set${upper}( ${name} );
EOM
	done

cat << EOM
	}
EOM
}

_jspank_generate_constructors_core() {
	local classname=${1} ; shift
	local start=${1}
	local idx

	if [ 0 = "${start}" ] ; then
cat << EOM
	public ${classname}() {
	}

EOM
	fi

	for idx in ${TYPE_IDXS} ; do
		local i=${start}
		local idxs=""
		while [ ${i} -le ${idx} ] ; do
			idxs="${idxs} ${i}"
			let i=${i}+1
		done
		_jspank_generate_constructor ${classname} ${idxs}
		echo
	done
}

_jspank_generate_constructors() {
	_jspank_generate_constructors_core ${1} 0
}
		
_jspank_generate_entity_constructors() {
	local classname=${1} ; shift
	_jspank_generate_constructors_core ${classname} 1 |\
   	sed "s,${classname},${classname}Entity,g;s,this,super,g"
}

_jspank_generate_base_constructors() {
	local classname=${1} ; shift
	_jspank_generate_constructors_core ${classname} 0 |\
   	sed "s,${classname},${classname}Base,g;"
}

_jspank_begin_class_pojo() {
	local classname=${1} ; shift
cat << EOM
import java.util.*;

public class ${classname} {
EOM
}

_jspank_begin_class_base() {
	local classname=${1} ; shift
cat << EOM
import java.io.Serializable;
import java.util.*;

public class ${classname}Base implements ${classname}, Serializable {
EOM
}

_jspank_begin_class_entity() {
	local classname=${1} ; shift
cat << EOM
import java.io.Serializable;
import java.util.*;
import javax.persistence.*;

@javax.persistence.Entity
public class ${classname}Entity extends ${classname}Base {
EOM
}

_jspank_begin_class_local() {
	local classname=${1} ; shift
cat << EOM
import java.util.*;
import javax.ejb.Local;

public interface ${classname}Local {
	public ${classname} find${classname}( long id );
	public List< ${classname} > find${classname}();
EOM
}

_jspank_begin_class_manager() {
	local classname=${1} ; shift
	local name=$( _jspank_first_down ${classname} )
cat << EOM
import java.util.*;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.PersistenceContext;
import javax.persistence.PersistenceUnit;
import javax.persistence.Query;

import javax.ejb.Stateless;

@Stateless
public class ${classname}Manager implements ${classname}Local {
	@PersistenceUnit 
	EntityManagerFactory entityManagerFactory;

	public EntityManager entityManager() {
		EntityManager entityManager = null;
		if ( null == entityManagerFactory ) {
			System.out.println( "entityManagerFactory is hosed" );
		} else {
			entityManager = entityManagerFactory.createEntityManager();
		}
		return entityManager;
	}

	public ${classname} find${classname}( long id ) {
		EntityManager entityManager = this.entityManager();
		return (
			null == entityManager
			? null
			: entityManager.find( ${classname}Entity.class, id )
		);
	}

	public List< ${classname} > find${classname}() {
		EntityManager entityManager = this.entityManager();
		List< ${classname} > list = null;
		if ( null != entityManager ) {
			list = entityManager.createQuery( "select x from ${classname}Entity x" ).getResultList();
		}
		return list;
	}

	public List< ${classname} > find${classname}( String name, Object value ) {
		EntityManager entityManager = this.entityManager();
		List< ${classname} > list = null;
		if ( null != entityManager ) {
			Query query = entityManager.createQuery( 
				"select x from ${classname}Entity x where " + name + " = :" + name
			);
			query.setParameter( name, value );
			list = query.getResultList();
		}
		return list;
	}

EOM
}

_jspank_begin_class_interface() {
	local classname=${1} ; shift
cat << EOM
import java.util.*;

public interface ${classname} {
EOM
}

_jspank_begin_class_managed() {
	local classname=${1} ; shift
	local name=$( _jspank_first_down ${classname} )
	local upper=$( _jspank_first_up ${name} )
cat << EOM
import java.util.*;

import java.util.logging.Level;
import java.util.logging.Logger;

import javax.faces.context.FacesContext;

import javax.ejb.EJB;

/*
<managed-bean>
	<managed-bean-name>Managed${classname}</managed-bean-name>
	<managed-bean-class>${_jspank_package}.Managed${classname}</managed-bean-class>
	<managed-bean-scope>request</managed-bean-scope>
</managed-bean>
*/
public class Managed${classname} {

	public static final String SUCCESS = "success";

	private static Logger logger = Logger.getLogger( Managed${classname}.class.getName() );

	@EJB
	private ${classname}Local service_;
	private ${classname} current_;
	private Collection< ${classname} > list_; // replace this with paged table

	////

	public void loadTable() {
		try {
			System.out.println( "load table... " );
			this.setList( this.getService().find${classname}() );
			System.out.println( "loaded table!"  + this.getList() );
		} catch ( Exception exception ) {
			logger.log( Level.SEVERE, exception.toString() );
		}
	}

	public boolean getHasCurrent() {
		return null != this.getCurrent();
	}

	public boolean getHasList() {
		this.loadTable();
		return null != this.getList() && !this.getList().isEmpty();
	}

	//// actions

	public String newAction() {
		this.setCurrent( new ${classname}Entity() );
		return SUCCESS;
	}

	public String createAction() {
		return this.updateAction();
	}

	public long current_id() { 
		return Long.valueOf( getRequestParameter( "Managed${classname}.current_id" ) ).longValue();
	}

	public String readAction() {
		try {
			this.setCurrent( 
				this.getService().find${classname}( this.current_id() ) // have to pull the id!
			);
		} catch ( Exception exception ) {
			logger.log( Level.SEVERE, exception.toString() );
		}
		return SUCCESS;
	}

	public String updateAction() { 
		try { 
			System.out.println( "updating " + this.getCurrent() );
			this.setCurrent( 
				this.getService().persist( this.getCurrent() )
			);
			System.out.println( "updated " + this.getCurrent() );
		} catch ( Exception exception ) {
			System.out.println( "persist err " + exception );
			logger.log( Level.SEVERE, exception.toString() );
		}
		System.out.println( "persisted" );
		return SUCCESS;
	}

	public String deleteAction() {
		try {
			this.getService().remove( this.current_id() ); // have to pull the id!
		} catch ( Exception exception ) {
			logger.log( Level.SEVERE, exception.toString() );
		}
		return SUCCESS;
	}

	//// getters and setters

	public ${classname}Local getService() {
		return this.service_;
	}

	public void setService( ${classname}Local service ) {
		this.service_ = service;
	}

	public ${classname} getCurrent() {
		return this.current_;
	}

	public void setCurrent( ${classname} ${name} ) {
		this.current_ = ${name};
	}

	public Collection< ${classname} > getList() {
		return this.list_;
	}

	public void setList( Collection< ${classname} > list ) {
		this.list_ = list;
	}

	////

	// this is totally nuts...
	public static String getRequestParameter(String name) {
		String value = null;
		try {
			value = (
				( String ) 
				FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap().get( name )
			);
		} catch ( Exception exception ) {
			logger.log( Level.SEVERE, exception.toString() );
		}
		return value;
	}

EOM
}

_jspank_begin_class() {
	local classname=${1} ; shift
	_jspank_log GENERATE ${_jspank_type}
	_jspank_begin_class_${_jspank_type} ${classname}
}

_jspank_end_class() {
	local classname=${1} ; shift
cat << EOM
};
EOM
}

_jspank_generate_to_string_bits_xml() {
	local type="${1}" ; shift
	local name="${1}" ; shift
	local upper=$( _jspank_first_up ${name} )
cat << EOM
			.append( ", \"${name}\":\"" )
			.append( this.get${upper}() )
			.append( "\"" )
EOM
}

_jspank_generate_to_string_xml() {
	local classname=${1} ; shift
	local lassname=$( _jspank_first_down ${classname} )
cat << EOM 
	public String toString() {
		return this.toStringBuilder().toString();
	}

	public StringBuilder toStringBuilder() {
		return this.toStringBuilder( new StringBuilder() );
	}

	public StringBuilder toStringBuilder( StringBuilder stringBuilder ) {
		return stringBuilder
			.append( "{\"classname\":\"${classname}\"" )
EOM
	_jspank_loop _jspank_generate_to_string_bits_xml
cat << EOM
			.append( "}" )
		;
	}

EOM
}

_jspank_generate_to_string_bits_json() {
	local type="${1}" ; shift
	local name="${1}" ; shift
	local upper=$( _jspank_first_up ${name} )
cat << EOM
			.append( "<${name}>" )
			.append( this.get${upper}() )
			.append( "</${name}>" )
EOM
}

_jspank_generate_to_string_json() {
	local classname=${1} ; shift
	local lassname=$( _jspank_first_down ${classname} )
cat << EOM 
	public String toString() {
		return this.toStringBuilder().toString();
	}

	public StringBuilder toStringBuilder() {
		return this.toStringBuilder( new StringBuilder() );
	}

	public StringBuilder toStringBuilder( StringBuilder stringBuilder ) {
		return stringBuilder
			.append( "<${lassname}>" )
EOM
	_jspank_loop _jspank_generate_to_string_bits_xml
cat << EOM
			.append( "</${lassname}>" )
		;
	}

EOM
}

_jspank_generate_to_string() {
	_jspank_generate_to_string_xml ${*}
}

_jspank_generate_copy_bit() {
	local type="${1}" ; shift
	local name="${1}" ; shift
	local upper=$( _jspank_first_up ${name} )
cat << EOM
		this.set${upper}( that.get${upper}() );
EOM
}

_jspank_generate_copy() {
	local classname=${1} ; shift
	local lassname=$( _jspank_first_down ${classname} )
cat << EOM 
	// you may need deep copies... sorry....
	public ${classname} copy( ${classname} that ) {
EOM
		_jspank_loop _jspank_generate_copy_bit
cat << EOM 
		return this;
	}

EOM
}

_jspank_one_of() {
	local x=${1} ; shift
	local yes="1"
	local arg
  	for arg in ${*} ; do
		if [ "${x}" = "${arg}" ] ; then
			yes="0"
			break
		fi
	done
	return ${yes}
}

_jspank_spit_package() {
cat << EOM
package ${*};

EOM
}

_jspank_generate_persist() {
	local classname=${1} ; shift
	local lower=$( _jspank_first_down ${classname} )
cat << EOM
	public ${classname}Entity toEntity( ${classname} ${lower} ) {
		return ( ${classname}Entity  ) ( new ${classname}Entity() ).copy( ${lower} );
	}

	public ${classname} persist( ${classname} ${lower} ) {
		return this.persistEntity(
			( ${lower} instanceof ${classname}Entity ) 
			? ( ${classname}Entity ) ${lower}
			: this.toEntity( ${lower} )
		);
	}

	public ${classname} persistEntity( ${classname}Entity ${lower} ) {
		EntityManager entityManager = this.entityManager();
		if ( null != entityManager ) {
			if ( 0 == ${lower}.getId() ) {
				entityManager.persist( ${lower} );
			} else {
				entityManager.merge( ${lower} );
			}
			entityManager.flush(); // this should not be needed...
		}
		return ${lower};
	}

	public void remove( ${classname}Entity ${lower} ) {
		EntityManager entityManager = this.entityManager();
		if ( null != entityManager ) {
			if ( 0 != ${lower}.getId() ) {
				${lower} = entityManager.merge( ${lower} );
			}
			entityManager.remove( ${lower} );
			entityManager.flush(); // this should not be needed...
		}
	}

	public void remove( long id ) {
		this.remove( ( ${classname}Entity ) this.find${classname}( id ) );
	}

EOM
}

_jspank_interface_filter() {
	grep public | sed 's, *{,;,'
}

#JSPANK_TYPE_ : POJO INTERFACE BASE ENTITY MANAGED LOCAL MANAGER
_jspank_generate() {
	local classname=${1} ; shift

	if [ "" != "${_jspank_package}" ] ; then
		_jspank_spit_package ${_jspank_package}
	fi

	_jspank_begin_class ${classname}

	_jspank_one_of "${_jspank_type}" ${JSPANK_TYPE_POJO} ${JSPANK_TYPE_BASE}
	if [ 0 = ${?} ] ; then
		_jspank_loop _jspank_generat_decl
		echo
	fi

	_jspank_one_of "${_jspank_type}" ${JSPANK_TYPE_POJO} 
	if [ 0 = ${?} ] ; then
		_jspank_generate_constructors ${classname}
	fi

	_jspank_one_of "${_jspank_type}" ${JSPANK_TYPE_BASE}
	if [ 0 = ${?} ] ; then
		_jspank_generate_base_constructors ${classname}
	fi

	_jspank_one_of "${_jspank_type}" ${JSPANK_TYPE_ENTITY}
	if [ 0 = ${?} ] ; then
		 _jspank_generate_entity_constructors ${classname}
		echo 
		_jspank_loop _jspank_generate_entity_gs
	fi

	_jspank_one_of "${_jspank_type}" ${JSPANK_TYPE_POJO} ${JSPANK_TYPE_BASE} 
	if [ 0 = ${?} ] ; then
		_jspank_loop _jspank_generate_gs
		_jspank_generate_to_string ${classname}
		_jspank_generate_copy ${classname}
	fi

	_jspank_one_of "${_jspank_type}" ${JSPANK_TYPE_INTERFACE} 
	if [ 0 = ${?} ] ; then
		_jspank_loop _jspank_generate_gs | _jspank_interface_filter
	fi

	_jspank_one_of "${_jspank_type}" ${JSPANK_TYPE_LOCAL} 
	if [ 0 = ${?} ] ; then
		_jspank_loop _jspank_generate_finders | _jspank_interface_filter
		_jspank_generate_persist ${classname} | _jspank_interface_filter
	fi

	_jspank_one_of "${_jspank_type}" ${JSPANK_TYPE_MANAGER} 
	if [ 0 = ${?} ] ; then
		_jspank_loop _jspank_generate_finders
	fi

	_jspank_one_of "${_jspank_type}" ${JSPANK_TYPE_MANAGER}
	if [ 0 = ${?} ] ; then
		_jspank_generate_persist ${classname}
	fi

	_jspank_end_class ${classname}
}

_jspank_classy() {
	local classname=${1} ; shift
	_jspank_accumulate_types
	_jspank_generate ${classname}
}

_jspank_usage() {
cat << EOM
	IOU
EOM
}

_jspank_main() {
	local classname=${1} ; shift
	if [ "" = "${classname}" ] ; then
		classname="CLASSNAME"
	fi

	if [ 1 = $( echo ${classname} | grep -c \\. ) ] ; then
		_jspank_package=$( echo ${classname} | sed 's,\.[^.]*$,,' )
		classname=$( echo ${classname} | sed 's,^.*\.,,' )
	fi

	_jspank_action=${JSPANK_GENERATE}
	_jspank_type=${JSPANK_TYPE_POJO}

	while [ 1 -le ${#} ] ; do
		case "${1}" in
			-t|-type|--type)
				shift
				if [ "" = "${1}" ] ; then
					_jspank_action=${JSPANK_USAGE}
				else 
					_jspank_type="${1}"
					shift;
				fi
				;;
			*) _jspank_action=${JSPANK_USAGE}
		esac
	done

	case "${_jspank_action}" in
		${JSPANK_GENERATE}) _jspank_classy $( echo ${classname} | sed 's,^HasXXX,Has,' ) ;;
		${JSPANK_USAGE})    _jspank_usage ;;
		${*}) echo noop ;;
	esac
}

_jspank_main ${*}
