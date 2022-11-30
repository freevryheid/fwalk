module fwalk
  implicit none
  private

  public :: say_hello
contains
  subroutine say_hello
    print *, "Hello, fwalk!"
  end subroutine say_hello
end module fwalk
