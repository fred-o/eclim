" Author:  Eric Van Dewoestine
"
" Description: {{{
"   Test case for junit.vim
"
" License:
"
" Copyright (C) 2005 - 2009  Eric Van Dewoestine
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.
"
" }}}

" SetUp() {{{
function! SetUp()
  exec 'cd ' . g:TestEclimWorkspace . 'eclim_unit_test_java'
endfunction " }}}

" TestJUnitImpl() {{{
function! TestJUnitImpl()
  edit! src/org/eclim/test/junit/SomeClassTestVUnit.java
  call PeekRedir()

  call cursor(3, 1)
  JUnitImpl
  call VUAssertTrue(bufname('%') =~ 'SomeClassTestVUnit.java_impl$',
    \ 'JUnit impl window not opened.')
  call VUAssertEquals('org.eclim.test.junit.SomeClassTestVUnit', getline(1),
    \ 'Wrong type in junit imple window.')

  call VUAssertTrue(search('^\s*public void aMethod()'),
    \ 'Super method aMethod() not found')
  call VUAssertTrue(search('^\s*public void aMethod(String name)'),
    \ 'Super method aMethod(String) not found')
  call VUAssertTrue(search('^\s*public abstract int compare(String o1, String o2)'),
    \ 'Super method compare() not found')

  call cursor(6, 1)
  exec "normal \<cr>"

  call cursor(12, 1)
  exec "normal Vj\<cr>"

  call VUAssertTrue(search('^\s*//public void aMethod()'),
    \ 'Super method aMethod() not commented out after add.')
  call VUAssertTrue(search('^\s*//public void aMethod(String name)'),
    \ 'Super method aMethod(String) not commented out after add.')
  call VUAssertTrue(search('^\s*//public abstract int compare(String o1, String o2)'),
    \ 'Super method compare() not commented out after add.')
  call VUAssertTrue(search('^\s*//public abstract boolean equals(Object obj)'),
    \ 'Super method equals() not commented out after add.')
  bdelete

  call VUAssertTrue(search('* @see org.eclim.test.junit.SomeClassVUnit#aMethod()$'),
    \ 'see testAMethod() not added.')
  call VUAssertTrue(search('* @see org.eclim.test.junit.SomeClassVUnit#aMethod(String)$'),
    \ 'see testAMethod(String) not added.')
  call VUAssertTrue(search('public void testAMethod()$'),
    \ 'testAMethod() not added.')
  call VUAssertTrue(search('* @see java.util.Comparator#compare(String,String)$'),
    \ 'see compare() not added.')
  call VUAssertTrue(search('public void testCompare()$'),
    \ 'testCompare() not added.')
  call VUAssertTrue(search('public void testEquals()$'),
    \ 'testEquals() not added.')
endfunction " }}}

" vim:ft=vim:fdm=marker
