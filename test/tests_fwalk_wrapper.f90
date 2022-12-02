module tests_fwalk_wrapper

	use, intrinsic :: iso_c_binding
	use testdrive
	use stdlib_string_type
	use fwalk
	use fwalk_common

	implicit none

	private

	public :: collect_tests_fwalk_wrapper

	contains

		subroutine collect_tests_fwalk_wrapper(testsuite)
			type(unittest_type),allocatable,intent(out)::testsuite(:)
			testsuite=[new_unittest("test wrapper",test_wrapper)]
		endsubroutine collect_tests_fwalk_wrapper

		subroutine test_wrapper(error)
			type(error_type),allocatable,intent(out)::error
			type(string_type),dimension(:),allocatable::relative_paths
			type(string_type),dimension(:),allocatable::absolute_paths
			character(len=:),allocatable::buf,path,basename,new_basename,new_root
			integer(kind=c_size_t)::length,ret,blen
			integer::i
			logical::chk
			type(cwk_segment)::segment

			blen=1000
			allocate(character(len=blen)::buf)

			! absolute and relative paths
			! relative_paths=[string_type(".."),&
			! &string_type("test"),&
			! &string_type("test/test"),&
			! &string_type("../another_test"),&
			! &string_type("./simple"),&
			! &string_type(".././simple")]
			! absolute_paths=[string_type("/"),&
			! &string_type("/test"),&
			! &string_type("/../test/"),&
			! &string_type("/../another_test"),&
			! &string_type("/./simple"),&
			! &string_type("/.././simple")]
			! call path_set_style(CWK_STYLE_UNIX)
			! do i=1,size(relative_paths)
			! 	chk=path_is_absolute(char(relative_paths(i)))
			! 	call check(error,chk,.false.)
			! enddo
			! do i=1,size(relative_paths)
			! 	chk=path_is_relative(char(relative_paths(i)))
			! 	call check(error,chk,.true.)
			! enddo
			! do i=1,size(absolute_paths)
			! 	chk=path_is_absolute(char(absolute_paths(i)))
			! 	call check(error,.not.chk,.false.)
			! enddo
			! do i=1,size(absolute_paths)
			! 	chk=path_is_absolute(char(absolute_paths(i)))
			! 	call check(error,chk,.true.)
			! enddo



			! base and path
			call path_set_style(CWK_STYLE_UNIX)
			path="/my/path.txt"
			call path_get_basename(path,basename,length)
			call check(error,basename(1:length),"path.txt")
			buf="/a/b/c"
			! ret=path_change_segment(segment,"/",buf,blen)
			chk=path_get_first_segment(buf,segment)
			chk=path_get_next_segment(segment)
			path="/my/path.txt/"
			call path_get_basename(path,basename,length)
			call check(error,basename(1:length),"path.txt")
			path="/my/path.zip////"
			call path_get_basename(path,basename,length)
			call check(error,basename(1:length),"path.zip")
			! path="///////////////////////////////////////" !
			! call path_get_basename(path,basename,length)
			path="/file/"
			call path_get_basename(path,basename,length)
			call check(error,basename(1:length),"file")
			! path=".."
			! call path_get_basename(path,basename,length)
			! call check(error,basename(1:length),"..")
			! path="."
			! call path_get_basename(path,basename,length)
			! call check(error,basename(1:length),".")
			! deallocate(path)
			! deallocate(basename)
			! path="/"
			! call path_get_basename(path,basename,length)
			! call check(error,basename,"")
			! deallocate(path)
			! deallocate(basename)
			! call path_set_style(CWK_STYLE_WINDOWS)
			! path="c:\path\test.txt"
			! call path_get_basename(path,basename,length)
			! call check(error,basename,"test.txt")
			! deallocate(path)
			! deallocate(basename)

		! change basename
			! call path_set_style(CWK_STYLE_UNIX)
			! path="/my/path.txt"
			! new_basename="new_path.txt"
			! blen=1000
			! allocate(character(len=blen)::buf)
			! ret=path_change_basename(path,new_basename,buf,blen)
			! call check(error,buf(1:ret),"/my/new_path.txt") ! buf is null-terminated
			! deallocate(path)

		! directory name
			! path="/my/path.txt"
			! call path_get_dirname(path,length)
			! call check(error,path(1:length),"/my/")
			! path="/one/two/three.txt"
			! call path_get_dirname(path,length)
			! call check(error,path(1:length),"/one/two/")
			! deallocate(path)

			! root
			! path="/my/path.txt"
			! call path_get_root(path,length)
			! call check(error,path(1:length),"/")
			! path="path.txt"
			! call path_get_root(path,length)
			! call check(error,int(length),0)
			! call path_set_style(CWK_STYLE_WINDOWS)
			! path="c:\my\path.txt"
			! call path_get_root(path,length)
			! call check(error,path(1:length),"c:\")

			! change root
			! call path_set_style(CWK_STYLE_UNIX)
			! path="/my/path.txt"
			! new_root="/not_my/"
			! blen=1000
			! deallocate(buf)
			! allocate(character(len=blen)::buf)
			! print*,buf
			! ret=path_change_root(path,new_root,buf,blen)
			! print*,buf
			! call check(error,buf(1:ret),"/not_my/new_path.txt") ! buf is null-terminated
			! deallocate(path)

			! join path
			! call path_set_style(CWK_STYLE_UNIX)
			! path="/my/path.txt"
			! new_root="/not_my/"
			! blen=1000
			! deallocate(buf)
			! allocate(character(len=blen)::buf)
			! ret=path_join(c_str("/first"),c_str("/second"),buf,blen)
			! call check(error,buf(1:ret),"/first/second") ! buf is null-terminated


			if (allocated(error)) return
		endsubroutine test_wrapper

endmodule tests_fwalk_wrapper
