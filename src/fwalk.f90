module fwalk

	use iso_c_binding
	use fwalk_common

	implicit none

	private

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
		character(kind=c_char)::path
		character(kind=c_char)::segments
		character(kind=c_char)::begin
		character(kind=c_char)::end
		integer(kind=c_size_t)::size
	endtype

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

		function path_get_absolute(base,path,buffer,buffer_size)&
		&bind(c,name="cwk_path_get_absolute")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::base
			character(kind=c_char)::path
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction path_get_absolute

		function path_get_relative(base_directory,path,buffer,buffer_size)&
		&bind(c,name="cwk_path_get_relative")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::base_directory
			character(kind=c_char)::path
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction path_get_relative

		function path_join(path_a,path_b,buffer,buffer_size)&
		&bind(c,name="cwk_path_join")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path_a
			character(kind=c_char)::path_b
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction path_join

		function path_join_multiple(paths,buffer,buffer_size)&
		&bind(c,name="cwk_path_join_multiple")&
		&result(ret)
			import c_size_t,c_char,c_ptr
			integer(kind=c_size_t)::ret
			type(c_ptr)::paths
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction path_join_multiple

		subroutine path_get_root(path,length)&
		&bind(c,name="cwk_path_get_root")
			import c_size_t,c_char
			character(kind=c_char)::path
			integer(kind=c_size_t)::length
		endsubroutine path_get_root

		function path_change_root(path,new_root,buffer,buffer_size)&
		&bind(c,name="cwk_path_change_root")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path
			character(kind=c_char)::new_root
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction path_change_root

		function path_is_absolute(path)&
		&bind(c,name="cwk_path_is_absolute")&
		&result(ret)
			import c_char,c_bool
			logical(kind=c_bool)::ret
			character(kind=c_char)::path
		endfunction path_is_absolute

		function path_is_relative(path)&
		&bind(c,name="cwk_path_is_relative")&
		&result(ret)
			import c_char,c_bool
			logical(kind=c_bool)::ret
			character(kind=c_char)::path
		endfunction path_is_relative

		subroutine cwk_path_get_basename(path,basename,length)&
		&bind(c,name="cwk_path_get_basename")
			import c_size_t,c_char,c_ptr
			character(kind=c_char)::path
			type(c_ptr)::basename
			integer(kind=c_size_t)::length
		endsubroutine cwk_path_get_basename

		function path_change_basename(path,new_basename,buffer,buffer_size)&
		&bind(c,name="cwk_path_change_basename")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path
			character(kind=c_char)::new_basename
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction path_change_basename

		subroutine path_get_dirname(path,length)&
		&bind(c,name="cwk_path_get_dirname")
			import c_size_t,c_char,c_ptr
			character(kind=c_char),intent(inout)::path
			integer(kind=c_size_t),intent(inout)::length
		endsubroutine path_get_dirname

		function path_get_extension(path,extension,length)&
		&bind(c,name="cwk_path_get_extension")&
		&result(ret)
			import c_char,c_bool,c_ptr,c_size_t
			logical(kind=c_bool)::ret
			character(kind=c_char)::path
			type(c_ptr)::extension
			integer(kind=c_size_t),value::length
		endfunction path_get_extension

		function path_has_extension(path)&
		&bind(c,name="cwk_path_has_extension")&
		&result(ret)
			import c_char,c_bool
			logical(kind=c_bool)::ret
			character(kind=c_char)::path
		endfunction path_has_extension

		function path_change_extension(path,new_extension,buffer,buffer_size)&
		&bind(c,name="cwk_path_change_extension")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path
			character(kind=c_char)::new_extension
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction path_change_extension

		function path_normalize(path,buffer,buffer_size)&
		&bind(c,name="cwk_path_normalize")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction path_normalize

		function path_get_intersection(path_base,path_other)&
		&bind(c,name="cwk_path_get_intersection")&
		&result(ret)
			import c_size_t,c_char
			integer(kind=c_size_t)::ret
			character(kind=c_char)::path_base
			character(kind=c_char)::path_other
		endfunction path_get_intersection

		function path_get_first_segment(path,segment)&
		&bind(c,name="cwk_path_get_first_segment")&
		&result(ret)
			import c_char,c_bool,cwk_segment
			logical(kind=c_bool)::ret
			type(cwk_segment)::segment
			character(kind=c_char)::path
		endfunction path_get_first_segment

		function path_get_last_segment(path,segment)&
		&bind(c,name="cwk_path_get_last_segment")&
		&result(ret)
			import c_char,c_bool,cwk_segment
			logical(kind=c_bool)::ret
			type(cwk_segment)::segment
			character(kind=c_char)::path
		endfunction path_get_last_segment

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

		function path_change_segment(segment,value,buffer,buffer_size)&
		&bind(c,name="cwk_path_change_segment")&
		&result(ret)
			import c_char,c_size_t,cwk_segment
			type(cwk_segment)::segment
			integer(kind=c_size_t)::ret
			character(kind=c_char)::value
			character(kind=c_char)::buffer
			integer(kind=c_size_t),value::buffer_size
		endfunction path_change_segment

		function path_is_separator(str)&
		&bind(c,name="cwk_path_is_separator")&
		&result(ret)
			import c_bool,c_char
			logical(kind=c_bool)::ret
			character(kind=c_char)::str
		endfunction path_is_separator

		function path_guess_style(path)&
		&bind(c,name="cwk_path_guess_style")&
		&result(ret)
			import cwk_path_style,c_char
			integer(kind(cwk_path_style))::ret
			character(kind=c_char)::path
		endfunction path_guess_style

		subroutine path_set_style(style)&
		&bind(c,name="cwk_path_set_style")
			import cwk_path_style
			integer(kind(cwk_path_style)),value::style
		endsubroutine path_set_style

		function path_get_style()&
		&bind(c,name="cwk_path_get_style")&
		&result(ret)
			import cwk_path_style,c_char
			integer(kind(cwk_path_style))::ret
		endfunction path_get_style

	endinterface

	contains

		subroutine path_get_basename(path,basename,length)
			character(len=*)::path
			character(len=:),allocatable::basename
			type(c_ptr)::basename_p
			integer(kind=c_size_t)::length
			call cwk_path_get_basename(path,basename_p,length)
			call c_f_str_ptr(basename_p,basename)
		endsubroutine path_get_basename

endmodule fwalk
