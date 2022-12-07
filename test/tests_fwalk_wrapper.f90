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
			character(len=:),allocatable::path,basename,new_basename,new_root,buf
			character(len=:),allocatable::extension
			integer::ret,length,blen,i
			logical::chk
			type(cwk_segment)::segment
			integer(kind(cwk_path_style))::style
			character(len=:),allocatable::begin
			blen=1000
			allocate(character(len=blen)::buf)

			! base and path
			call path_set_style(CWK_STYLE_UNIX)

			path="/my/"
			call path_get_basename(path,basename,length)
			call check(error,basename(1:length),"my")

			call path_get_basename("/not_my",basename,length)
			call check(error,basename(1:length),"not_my")

			path="/my/path.txt"
			call path_get_basename(path,basename,length)
			call check(error,basename(1:length),"path.txt")

			path="/my/path.zip////"
			call path_get_basename(path,basename,length)
			call check(error,basename(1:length),"path.zip")

			path="///////////////////////////////////////"
			call path_get_basename(path,basename,length)
			call check(error,length,0)

			path="/"
			call path_get_basename(path,basename,length)
			call check(error,length,0)

			path=".."
			call path_get_basename(path,basename,length)
			call check(error,basename(1:length),path)

			path="filename"
			call path_get_basename(path,basename,length)
			call check(error,basename(1:length),path)

			path='.'
			call path_get_basename(path,basename,length)
			call check(error,basename(1:length),path)

			call path_set_style(CWK_STYLE_WINDOWS)
			path="c:\path\test.txt"
			call path_get_basename(path,basename,length)
			call check(error,basename(1:length),"test.txt")

			! change basename
			call path_set_style(CWK_STYLE_UNIX)
			path="/my/path.txt"
			new_basename="new_path.txt"
			ret=path_change_basename(path,new_basename,buf,blen)
			call check(error,buf(1:ret),"/my/new_path.txt")

			call path_set_style(CWK_STYLE_WINDOWS)
			path="d:\my\path.txt"
			new_basename="new_path.txt"
			ret=path_change_basename(path,new_basename,buf,blen)
			call check(error,buf(1:ret),"d:\my\new_path.txt")

			! directory name
			call path_set_style(CWK_STYLE_UNIX)
			path="/my/path.txt"
			call path_get_dirname(path,length)
			call check(error,path(1:length),"/my/")
			path="/one/two/three.txt"
			call path_get_dirname(path,length)
			call check(error,path(1:length),"/one/two/")
			path="filename"
			call path_get_dirname(path,length)
			call check(error,length,0)
			path=""
			call path_get_dirname(path,length)
			call check(error,length,0)

			! root
			path="/my/path.txt"
			call path_get_root(path,length)
			call check(error,path(1:length),"/")
			path="path.txt"
			call path_get_root(path,length)
			call check(error,int(length),0)
			path="\folder\"
			call path_get_root(path,length)
			call check(error,length,0)
			call path_set_style(CWK_STYLE_WINDOWS)
			path="c:\my\path.txt"
			call path_get_root(path,length)
			call check(error,path(1:length),"c:\")

			! change root
			call path_set_style(CWK_STYLE_UNIX)
			path="/my/path.txt"
			new_root="/not_my/"
			ret=path_change_root(path,new_root,buf,blen)
			call check(error,buf(1:ret),"/not_my/my/path.txt")
			path="path.txt"
			new_root="/my/"
			ret=path_change_root(path,new_root,buf,blen)
			call check(error,buf(1:ret),"/my/path.txt")

			! absolute and relative paths
			relative_paths=[string_type(".."),&
			&string_type("test"),&
			&string_type("test/test"),&
			&string_type("../another_test"),&
			&string_type("./simple"),&
			&string_type(".././simple")]
			absolute_paths=[string_type("/"),&
			&string_type("/test"),&
			&string_type("/../test/"),&
			&string_type("/../another_test"),&
			&string_type("/./simple"),&
			&string_type("/.././simple")]
			call path_set_style(CWK_STYLE_UNIX)
			do i=1,size(relative_paths)
				path=char(relative_paths(i))
				chk=path_is_absolute(path)
				call check(error,chk,.false.)
			enddo
			do i=1,size(relative_paths)
				path=char(relative_paths(i))
				chk=path_is_relative(path)
				call check(error,chk,.true.)
			enddo
			do i=1,size(absolute_paths)
				path=char(absolute_paths(i))
				chk=path_is_absolute(path)
				call check(error,.not.chk,.false.)
			enddo
			do i=1,size(absolute_paths)
				path=char(absolute_paths(i))
				chk=path_is_absolute(path)
				call check(error,chk,.true.)
			enddo

			! join path
			call path_set_style(CWK_STYLE_UNIX)
			ret=path_join("/first","/second",buf,blen)
			call check(error,buf(1:ret),"/first/second")
			ret=path_join("hello","..",buf,blen)
			call check(error,buf(1:ret),".")
			ret=path_join("hello/there","..",buf,blen)
			call check(error,buf(1:ret),"hello")
			ret=path_join("hello/there","../world",buf,blen)
			call check(error,buf(1:ret),"hello/world")
			call path_set_style(CWK_STYLE_WINDOWS)
			ret=path_join("this\","c:\..\..\is\a\test\",buf,blen)
			call check(error,buf(1:ret),"is\a\test")

			! TODO multiple paths array

			! normalize path
			call path_set_style(CWK_STYLE_UNIX)
			ret=path_normalize("/var",buf,blen)
			call check(error,buf(1:ret),"/var")
			ret=path_normalize("/var/logs/test/../../",buf,blen)
			call check(error,buf(1:ret),"/var")
			ret=path_normalize("/var/logs/test/../../../../../../",buf,blen)
			call check(error,buf(1:ret),"/")
			ret=path_normalize("rel/../../",buf,blen)
			call check(error,buf(1:ret),"..")
			ret=path_normalize("/var////logs//test/",buf,blen)
			call check(error,buf(1:ret),"/var/logs/test")
			ret=path_normalize("/var/./logs/.//test/..//..//////",buf,blen)
			call check(error,buf(1:ret),"/var")

			! path_get_intersection
			ret=path_get_intersection("/test/abc/../foo/bar","/test/foo/har")
			call check(error,ret,16)

			! get absolute path
			ret=path_get_absolute("/hello/there","../../../../../",buf,blen)
			call check(error,buf(1:ret),"/")
			ret=path_get_absolute("/hello//../there","test//thing",buf,blen)
			call check(error,buf(1:ret),"/there/test/thing")

			! get relative path
			ret=path_get_relative("/../../","/../../",buf,blen)
			call check(error,buf(1:ret),".")
			ret=path_get_relative("/path/same","/path/not_same/ho/..",buf,blen)
			call check(error,buf(1:ret),"../not_same")

			! get extension
			chk= path_get_extension("/my/path.txt",extension,length)
			call check(error,chk,.true.)
			call check(error,extension(1:length),".txt")
			chk= path_get_extension("/my/path.abc.txt.tests",extension,length)
			call check(error,extension(1:length),".tests")
			chk= path_get_extension("/my/path",extension,length)
			call check(error,chk,.false.)

			! has extension
			chk= path_has_extension("/my/path.txt")
			call check(error,chk,.true.)
			chk= path_has_extension("/my/path")
			call check(error,chk,.false.)


			! change extension
			call path_set_style(CWK_STYLE_UNIX)
			ret=path_change_extension("/my/path.txt","md",buf,blen)
			call check(error,buf(1:ret),"/my/path.md")
			call path_set_style(CWK_STYLE_WINDOWS)
			ret=path_change_extension("c:\path.txt","md",buf,blen)
			call check(error,buf(1:ret),"c:\path.md")

			! style
			style=path_get_style()
			call check(error,style,CWK_STYLE_WINDOWS)
			call path_set_style(CWK_STYLE_UNIX)
			style=path_get_style()
			call check(error,style,CWK_STYLE_UNIX)

			! guess style
			style=path_guess_style("/a/directory/myfile.txt")
			call check(error,style,CWK_STYLE_UNIX)

			! get first segment
			call path_set_style(CWK_STYLE_UNIX)
			segment=cwk_segment(path="       ",segments="        ",begin="          ",end="        ",size=0)
			chk=path_get_first_segment("/my/path.txt",segment)
			if(chk)then
				! if(c_associated(segment%begin))then
				! 	call c_f_str_ptr(segment%begin,begin)
				! 	print *,begin
				! 	write(*,'(a,a)')"segment is ",begin(1:segment%size)
				! endif
				write(*,'(a,i0)')"segment length is ",segment%size
			else
				print*,"no segments in path"
			endif

			if (allocated(error)) return
		endsubroutine test_wrapper

endmodule tests_fwalk_wrapper
