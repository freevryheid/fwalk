module fwalk

	use iso_c_binding
	use fwalk_common

	implicit none

	private

	integer,parameter::blen=255

	public::cwk_segment_type,CWK_NORMAL,CWK_CURRENT,CWK_BACK
	public::cwk_path_style,CWK_STYLE_WINDOWS,CWK_STYLE_UNIX
	public::path_get_absolute,path_get_relative,path_join
	public::path_join_multiple,path_get_root,path_change_root
	public::path_is_absolute,path_is_relative
	public::path_get_basename,path_change_basename,path_get_dirname
	public::path_get_extension,path_has_extension,path_change_extension
	public::path_normalize,path_get_intersection
	public::path_get_first_segment,path_get_last_segment
	public::path_get_next_segment,path_get_previous_segment
	public::path_get_segment_type,path_change_segment
	public::path_is_separator,path_guess_style
	public::path_set_style,path_get_style

	type,public,bind(c)::cwk_segment
		type(c_ptr)::path=c_null_ptr
		type(c_ptr)::segments=c_null_ptr
		type(c_ptr)::begin=c_null_ptr
		type(c_ptr)::end=c_null_ptr
		integer(kind=c_size_t)::size=0
	endtype

	! type,public,bind(c)::cwk_segment
	! 	character(kind=c_char)::path=c_null_char
	! 	character(kind=c_char)::segments=c_null_char
	! 	character(kind=c_char)::begin=c_null_char
	! 	character(kind=c_char)::end=c_null_char
	! 	integer(kind=c_size_t)::size=0
	! endtype

	enum,bind(c)
		enumerator::cwk_segment_type=0
		enumerator::CWK_NORMAL=0
		enumerator::CWK_CURRENT=1
		enumerator::CWK_BACK=2
	endenum

	enum,bind(c)
		enumerator::cwk_path_style=0
		enumerator::CWK_STYLE_WINDOWS=0
		enumerator::CWK_STYLE_UNIX=1
	endenum

	interface

		function cwk_path_get_absolute(base,path,buffer,buffer_size)&
		&bind(c,name="cwk_path_get_absolute")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::base
			character(kind=c_char)::path
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction cwk_path_get_absolute

		function cwk_path_get_relative(base_directory,path,buffer,buffer_size)&
		&bind(c,name="cwk_path_get_relative")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::base_directory
			character(kind=c_char)::path
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction cwk_path_get_relative

		function cwk_path_join(path_a,path_b,buffer,buffer_size)&
		&bind(c,name="cwk_path_join")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path_a
			character(kind=c_char)::path_b
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction cwk_path_join

		function cwk_path_join_multiple(paths,buffer,buffer_size)&
		&bind(c,name="cwk_path_join_multiple")&
		&result(ret)
			import c_size_t,c_char,c_ptr
			integer(kind=c_size_t)::ret
			type(c_ptr)::paths
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction cwk_path_join_multiple

		subroutine cwk_path_get_root(path,length)&
		&bind(c,name="cwk_path_get_root")
			import c_size_t,c_char
			character(kind=c_char)::path
			integer(kind=c_size_t)::length
		endsubroutine cwk_path_get_root

		function cwk_path_change_root(path,new_root,buffer,buffer_size)&
		&bind(c,name="cwk_path_change_root")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path
			character(kind=c_char)::new_root
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction cwk_path_change_root

		function cwk_path_is_absolute(path)&
		&bind(c,name="cwk_path_is_absolute")&
		&result(ret)
			import c_char,c_bool
			logical(kind=c_bool)::ret
			character(kind=c_char)::path
		endfunction cwk_path_is_absolute

		function cwk_path_is_relative(path)&
		&bind(c,name="cwk_path_is_relative")&
		&result(ret)
			import c_char,c_bool
			logical(kind=c_bool)::ret
			character(kind=c_char)::path
		endfunction cwk_path_is_relative

		subroutine cwk_path_get_basename(path,basename,length)&
		&bind(c,name="cwk_path_get_basename")
			import c_size_t,c_char,c_ptr
			character(kind=c_char)::path
			type(c_ptr)::basename
			integer(kind=c_size_t)::length
		endsubroutine cwk_path_get_basename

		function cwk_path_change_basename(path,new_basename,buffer,buffer_size)&
		&bind(c,name="cwk_path_change_basename")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path
			character(kind=c_char)::new_basename
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction cwk_path_change_basename

		subroutine cwk_path_get_dirname(path,length)&
		&bind(c,name="cwk_path_get_dirname")
			import c_size_t,c_char
			character(kind=c_char)::path
			integer(kind=c_size_t)::length
		endsubroutine cwk_path_get_dirname

		function cwk_path_get_extension(path,extension,length)&
		&bind(c,name="cwk_path_get_extension")&
		&result(ret)
			import c_char,c_bool,c_ptr,c_size_t
			logical(kind=c_bool)::ret
			character(kind=c_char)::path
			type(c_ptr)::extension
			integer(kind=c_size_t)::length
		endfunction cwk_path_get_extension

		function cwk_path_has_extension(path)&
		&bind(c,name="cwk_path_has_extension")&
		&result(ret)
			import c_char,c_bool
			logical(kind=c_bool)::ret
			character(kind=c_char)::path
		endfunction cwk_path_has_extension

		function cwk_path_change_extension(path,new_extension,buffer,buffer_size)&
		&bind(c,name="cwk_path_change_extension")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path
			character(kind=c_char)::new_extension
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction cwk_path_change_extension

		function cwk_path_normalize(path,buffer,buffer_size)&
		&bind(c,name="cwk_path_normalize")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction cwk_path_normalize

		function cwk_path_get_intersection(path_base,path_other)&
		&bind(c,name="cwk_path_get_intersection")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path_base
			character(kind=c_char)::path_other
		endfunction cwk_path_get_intersection

		function cwk_path_get_first_segment(path,segment)&
		&bind(c,name="cwk_path_get_first_segment")&
		&result(ret)
			import c_char,c_bool,cwk_segment,c_ptr
			logical(kind=c_bool)::ret
			type(cwk_segment)::segment
			character(kind=c_char)::path
		endfunction cwk_path_get_first_segment

		function cwk_path_get_last_segment(path,segment)&
		&bind(c,name="cwk_path_get_last_segment")&
		&result(ret)
			import c_char,c_bool,cwk_segment
			logical(kind=c_bool)::ret
			type(cwk_segment)::segment
			character(kind=c_char)::path
		endfunction cwk_path_get_last_segment

		function path_get_next_segment(segment)&
		&bind(c,name="cwk_path_get_next_segment")&
		&result(ret)
			import c_bool,cwk_segment
			logical(kind=c_bool)::ret
			type(cwk_segment)::segment
		endfunction path_get_next_segment

		function path_get_previous_segment(segment)&
		&bind(c,name="cwk_path_get_previous_segment")&
		&result(ret)
			import c_bool,cwk_segment
			logical(kind=c_bool)::ret
			type(cwk_segment)::segment
		endfunction path_get_previous_segment

		function path_get_segment_type(segment)&
		&bind(c,name="cwk_path_get_segment_type")&
		&result(ret)
			import cwk_segment_type,cwk_segment
			integer(kind(cwk_segment_type))::ret
			type(cwk_segment)::segment
		endfunction path_get_segment_type

		function cwk_path_change_segment(segment,value,buffer,buffer_size)&
		&bind(c,name="cwk_path_change_segment")&
		&result(ret)
			import c_char,c_size_t,cwk_segment
			type(cwk_segment)::segment
			integer(kind=c_size_t)::ret
			character(kind=c_char)::value
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction cwk_path_change_segment

		function path_is_separator(str)&
		&bind(c,name="cwk_path_is_separator")&
		&result(ret)
			import c_bool,c_char
			logical(kind=c_bool)::ret
			character(kind=c_char)::str
		endfunction path_is_separator

		function cwk_path_guess_style(path)&
		&bind(c,name="cwk_path_guess_style")&
		&result(ret)
			import cwk_path_style,c_char
			integer(kind(cwk_path_style))::ret
			character(kind=c_char)::path
		endfunction cwk_path_guess_style

		subroutine path_set_style(style)&
		&bind(c,name="cwk_path_set_style")
			import cwk_path_style
			integer(kind(cwk_path_style)),value::style
		endsubroutine path_set_style

		function path_get_style()&
		&bind(c,name="cwk_path_get_style")&
		&result(ret)
			import cwk_path_style
			integer(kind(cwk_path_style))::ret
		endfunction path_get_style

	endinterface

	contains

		subroutine path_get_basename(path,basename,length)
			character(len=*)::path
			character(len=:),allocatable::basename,cpath
			type(c_ptr)::basename_p
			integer::length
			integer(kind=c_size_t)::clength
			cpath=c_str(path)
			call cwk_path_get_basename(cpath,basename_p,clength)
			length=int(clength)
			if(c_associated(basename_p))then
				call c_f_str_ptr(basename_p,basename)
			else
				basename=""
			endif
		endsubroutine path_get_basename

		function path_change_basename(path,new_basename,buffer,buffer_size)&
		&result(ret)
			integer::ret,buffer_size
			character(len=*)::path,new_basename,buffer
			character(len=:),allocatable::cpath,cnew_basename
			cpath=c_str(path)
			cnew_basename=c_str(new_basename)
			ret=int(cwk_path_change_basename(cpath,cnew_basename,buffer,int(buffer_size,kind=c_size_t)))
		endfunction path_change_basename

		subroutine path_get_dirname(path,length)
			character(len=*)::path
			character(len=:),allocatable::cpath
			integer::length
			integer(kind=c_size_t)::clength
			cpath=c_str(path)
			call cwk_path_get_dirname(cpath,clength)
			length=int(clength)
		endsubroutine path_get_dirname

		subroutine path_get_root(path,length)
			character(len=*)::path
			character(len=:),allocatable::cpath
			integer::length
			integer(kind=c_size_t)::clength
			cpath=c_str(path)
			call cwk_path_get_root(cpath,clength)
			length=int(clength)
		endsubroutine path_get_root

		function path_change_root(path,new_root,buffer,buffer_size)&
		&result(ret)
			integer::ret,buffer_size
			character(len=*)::path,new_root,buffer
			character(len=:),allocatable::cpath,cnew_root
			cpath=c_str(path)
			cnew_root=c_str(new_root)
			ret=int(cwk_path_change_root(cpath,cnew_root,buffer,int(buffer_size,kind=c_size_t)))
		endfunction path_change_root

		function path_is_absolute(path)&
		&result(ret)
			logical(kind=c_bool)::ret
			character(len=*)::path
			character(len=:),allocatable::cpath
			cpath=c_str(path)
			ret=cwk_path_is_absolute(cpath)
		endfunction path_is_absolute

		function path_is_relative(path)&
		&result(ret)
			logical(kind=c_bool)::ret
			character(len=*)::path
			character(len=:),allocatable::cpath
			cpath=c_str(path)
			ret=cwk_path_is_relative(cpath)
		endfunction path_is_relative

		function path_join(path_a,path_b,buffer,buffer_size)&
		&result(ret)
			integer::ret,buffer_size
			character(len=*)::path_a,path_b,buffer
			character(len=:),allocatable::cpath_a,cpath_b
			cpath_a=c_str(path_a)
			cpath_b=c_str(path_b)
			ret=int(cwk_path_join(cpath_a,cpath_b,buffer,int(buffer_size,kind=c_size_t)))
		endfunction path_join

		function path_normalize(path,buffer,buffer_size)&
		&result(ret)
			integer::ret,buffer_size
			character(len=*)::path,buffer
			character(len=:),allocatable::cpath
			cpath=c_str(path)
			ret=int(cwk_path_normalize(cpath,buffer,int(buffer_size,kind=c_size_t)))
		endfunction path_normalize

		function path_get_intersection(path_base,path_other)&
		&result(ret)
			integer::ret
			character(len=*)::path_base,path_other
			character(len=:),allocatable::cpath_base,cpath_other
			cpath_base=c_str(path_base)
			cpath_other=c_str(path_other)
			ret=int(cwk_path_get_intersection(cpath_base,cpath_other))
		endfunction path_get_intersection

		function path_get_absolute(base,path,buffer,buffer_size)&
		&result(ret)
			integer::ret,buffer_size
			character(len=*)::base,path,buffer
			character(len=:),allocatable::cbase,cpath
			cbase=c_str(base)
			cpath=c_str(path)
			ret=int(cwk_path_get_absolute(cbase,cpath,buffer,int(buffer_size,kind=c_size_t)))
		endfunction path_get_absolute

		function path_get_relative(base_directory,path,buffer,buffer_size)&
		&result(ret)
			integer::ret,buffer_size
			character(len=*)::base_directory,path,buffer
			character(len=:),allocatable::cbase_directory,cpath
			cbase_directory=c_str(base_directory)
			cpath=c_str(path)
			ret=int(cwk_path_get_relative(cbase_directory,cpath,buffer,int(buffer_size,kind=c_size_t)))
		endfunction path_get_relative

		function path_get_extension(path,extension,length)&
		&result(ret)
			logical::ret
			character(len=*)::path
			character(len=:),allocatable::extension,cpath
			type(c_ptr)::extension_p
			integer::length
			integer(kind=c_size_t)::clength
			cpath=c_str(path)
			ret=cwk_path_get_extension(cpath,extension_p,clength)
			length=int(clength)
			if(c_associated(extension_p))then
				call c_f_str_ptr(extension_p,extension)
			else
				extension=""
			endif
		endfunction path_get_extension

		function path_has_extension(path)&
		&result(ret)
			logical::ret
			character(len=*)::path
			character(len=:),allocatable::cpath
			cpath=c_str(path)
			ret=cwk_path_has_extension(cpath)
		endfunction path_has_extension

		function path_change_extension(path,new_extension,buffer,buffer_size)&
		&result(ret)
			integer::ret,buffer_size
			character(len=*)::path,new_extension,buffer
			character(len=:),allocatable::cpath,cnew_extension
			cpath=c_str(path)
			cnew_extension=c_str(new_extension)
			ret=int(cwk_path_change_extension(cpath,cnew_extension,buffer,int(buffer_size,kind=c_size_t)))
		endfunction path_change_extension

		function path_guess_style(path)&
		&result(ret)
			integer(kind(cwk_path_style))::ret
			character(len=*)::path
			character(len=:),allocatable::cpath
			cpath=c_str(path)
			ret=cwk_path_guess_style(cpath)
		endfunction path_guess_style

		function path_get_first_segment(path,segment)&
		&result(ret)
			logical::ret
			type(cwk_segment)::segment
			character(len=*)::path
			character(len=:),allocatable::cpath
			cpath=c_str(path)
			ret=cwk_path_get_first_segment(cpath,segment)
		endfunction path_get_first_segment

		function path_get_last_segment(path,segment)&
		&result(ret)
			logical::ret
			type(cwk_segment)::segment
			character(len=*)::path
			character(len=:),allocatable::cpath
			cpath=c_str(path)
			ret=cwk_path_get_last_segment(cpath,segment)
		endfunction path_get_last_segment

		function path_change_segment(segment,value,buffer,buffer_size)&
		&result(ret)
			type(cwk_segment)::segment
			integer::ret,buffer_size
			character(len=*)::value,buffer
			character(len=:),allocatable::cvalue
			cvalue=c_str(value)
			ret=int(cwk_path_change_segment(segment,cvalue,buffer,int(buffer_size,kind=c_size_t)))
		endfunction path_change_segment

		function path_join_multiple(paths,buffer,buffer_size)&
		&result(ret)
			integer::ret,buffer_size,i
			character(len=*),target::paths(:)
			character(len=*)::buffer
			type(c_ptr),dimension(size(paths))::ptrs
			do i=1,size(paths)
				paths(i)=c_str(paths(i))
				if(i.eq.size(paths))then
					ptrs(i)=c_null_ptr
				else
					ptrs(i)=c_loc(paths(i))
				endif
			end do
			ret=int(cwk_path_join_multiple(ptrs,buffer,int(buffer_size,kind=c_size_t)))
		endfunction path_join_multiple

endmodule fwalk
