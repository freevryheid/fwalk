module fwalk_common

	use,intrinsic::iso_c_binding

	implicit none

	private

	public::c_strlen
	public::c_f_str_ptr
	public::c_str
	public::copy

	interface

		function c_strlen(str)bind(c,name='strlen')
			import::c_ptr,c_size_t
			implicit none
			type(c_ptr),intent(in),value::str
			integer(c_size_t)::c_strlen
		endfunction c_strlen

	endinterface

	contains

		pure function copy(a)
			character,intent(in)::a(:)
			character(len=size(a))::copy
			integer(kind=c_size_t)::i
			do i=1,size(a)
				copy(i:i)=a(i)
			enddo
		endfunction copy

		subroutine c_f_str_ptr(cstr,fstr)
			type(c_ptr),intent(in)::cstr
			character(len=:),allocatable,intent(out)::fstr
			character(kind=c_char),pointer::ptrs(:)
			integer(kind=c_size_t)::sz
			if(.not.c_associated(cstr))then
				fstr=""
				return
			endif
			sz=c_strlen(cstr)
			if(sz.lt.0)then
				fstr=""
				return
			endif
			call c_f_pointer(cstr,ptrs,[sz])
			allocate(character(len=sz)::fstr)
			fstr=copy(ptrs)
		endsubroutine c_f_str_ptr

		function c_str(fstr)result(cstr)
			character(len=*),intent(in)::fstr
			character(kind=c_char,len=:),allocatable::cstr
			cstr=trim(fstr)//c_null_char
		endfunction c_str

endmodule fwalk_common
