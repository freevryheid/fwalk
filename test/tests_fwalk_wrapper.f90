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
			type(string_type),dimension(:),allocatable::relative_paths,absolute_paths
			character(len=:),allocatable::path,basename,new_basename,new_root,extension
			character(len=:),allocatable::tpath,tsegments,tbegin,tend
			character(len=1000)::buf
			character(len=15),dimension(3)::paths
			integer::ret,length,i
			logical::chk
			type(cwk_segment)::segment
			integer(kind(cwk_path_style))::style

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
			ret=path_change_basename(path,new_basename,buf,len(buf))
			call check(error,buf(1:ret),"/my/new_path.txt")
			call path_set_style(CWK_STYLE_WINDOWS)
			path="d:\my\path.txt"
			new_basename="new_path.txt"
			ret=path_change_basename(path,new_basename,buf,len(buf))
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
			ret=path_change_root(path,new_root,buf,len(buf))
			call check(error,buf(1:ret),"/not_my/my/path.txt")
			path="path.txt"
			new_root="/my/"
			ret=path_change_root(path,new_root,buf,len(buf))
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
			ret=path_join("/first","/second",buf,len(buf))
			call check(error,buf(1:ret),"/first/second")
			ret=path_join("hello","..",buf,len(buf))
			call check(error,buf(1:ret),".")
			ret=path_join("hello/there","..",buf,len(buf))
			call check(error,buf(1:ret),"hello")
			ret=path_join("hello/there","../world",buf,len(buf))
			call check(error,buf(1:ret),"hello/world")
			call path_set_style(CWK_STYLE_WINDOWS)
			ret=path_join("this\","c:\..\..\is\a\test\",buf,len(buf))
			call check(error,buf(1:ret),"is\a\test")

			! join multiple paths array
			call path_set_style(CWK_STYLE_UNIX)
			paths(1)="hello/there"
			paths(2)="../world"
			paths(3)=""
			ret=path_join_multiple(paths,buf,len(buf))
			call check(error,buf(1:ret),"hello/world")

			! normalize path
			call path_set_style(CWK_STYLE_UNIX)
			ret=path_normalize("/var",buf,len(buf))
			call check(error,buf(1:ret),"/var")
			ret=path_normalize("/var/logs/test/../../",buf,len(buf))
			call check(error,buf(1:ret),"/var")
			ret=path_normalize("/var/logs/test/../../../../../../",buf,len(buf))
			call check(error,buf(1:ret),"/")
			ret=path_normalize("rel/../../",buf,len(buf))
			call check(error,buf(1:ret),"..")
			ret=path_normalize("/var////logs//test/",buf,len(buf))
			call check(error,buf(1:ret),"/var/logs/test")
			ret=path_normalize("/var/./logs/.//test/..//..//////",buf,len(buf))
			call check(error,buf(1:ret),"/var")

			! path_get_intersection
			ret=path_get_intersection("/test/abc/../foo/bar","/test/foo/har")
			call check(error,ret,16)

			! get absolute path
			ret=path_get_absolute("/hello/there","../../../../../",buf,len(buf))
			call check(error,buf(1:ret),"/")
			ret=path_get_absolute("/hello//../there","test//thing",buf,len(buf))
			call check(error,buf(1:ret),"/there/test/thing")

			! get relative path
			ret=path_get_relative("/../../","/../../",buf,len(buf))
			call check(error,buf(1:ret),".")
			ret=path_get_relative("/path/same","/path/not_same/ho/..",buf,len(buf))
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
			ret=path_change_extension("/my/path.txt","md",buf,len(buf))
			call check(error,buf(1:ret),"/my/path.md")
			call path_set_style(CWK_STYLE_WINDOWS)
			ret=path_change_extension("c:\path.txt","md",buf,len(buf))
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
			segment=cwk_segment()
			chk=path_get_first_segment("/my123456/path.txt",segment)
			if(chk)then
				print*,"convert"
				call c_f_str_ptr(segment%begin,tbegin)
				call check(error,tbegin,"my123456")
			else
				print*,"no segments in path"
			endif

			if (allocated(error)) return
		endsubroutine test_wrapper

endmodule tests_fwalk_wrapper
