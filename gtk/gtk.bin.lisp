;;; ----------------------------------------------------------------------------
;;; gtk.bin.lisp
;;;
;;; This file contains code from a fork of cl-gtk2.
;;; See http://common-lisp.net/project/cl-gtk2/
;;;
;;; The documentation has been copied from the GTK+ 3 Reference Manual
;;; Version 3.4.1. See http://www.gtk.org.
;;;
;;; Copyright (C) 2009 - 2011 Kalyanov Dmitry
;;; Copyright (C) 2011 - 2013 Dieter Kaiser
;;;
;;; This program is free software: you can redistribute it and/or modify
;;; it under the terms of the GNU Lesser General Public License for Lisp
;;; as published by the Free Software Foundation, either version 3 of the
;;; License, or (at your option) any later version and with a preamble to
;;; the GNU Lesser General Public License that clarifies the terms for use
;;; with Lisp programs and is referred as the LLGPL.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU Lesser General Public License for more details.
;;;
;;; You should have received a copy of the GNU Lesser General Public
;;; License along with this program and the preamble to the Gnu Lesser
;;; General Public License.  If not, see <http://www.gnu.org/licenses/>
;;; and <http://opensource.franz.com/preamble.html>.
;;; ----------------------------------------------------------------------------
;;;
;;; GtkBin
;;; 
;;; A container with just one child
;;;     
;;; Synopsis
;;; 
;;;     GtkBin
;;;     
;;;     gtk_bin_get_child
;;; ----------------------------------------------------------------------------

(in-package :gtk)

;;; ----------------------------------------------------------------------------
;;; struct GtkBin
;;; ----------------------------------------------------------------------------

(define-g-object-class "GtkBin" gtk-bin
  (:superclass gtk-container
   :export t
   :interfaces ("AtkImplementorIface" "GtkBuildable")
   :type-initializer "gtk_bin_get_type")
  nil)

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation 'gtk-bin 'type)
 "@version{2013-2-12}
  @short{The @class{gtk-bin} widget is a container with just one child.}
  It is not very useful itself, but it is useful for deriving subclasses, since
  it provides common code needed for handling a single child widget.

  Many GTK+ widgets are subclasses of @class{gtk-bin}, including
  @class{gtk-window}, @class{gtk-button}, @class{gtk-frame},
  @class{gtk-handle-box} or @class{gtk-scroll-window}.")

;;; ----------------------------------------------------------------------------
;;; gtk_bin_get_child ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_bin_get_child" gtk-bin-get-child) (g-object gtk-widget)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-12}
  @argument[bin]{a @class{gtk-bin} widget}
  @return{pointer to child of the @class{gtk-bin}}
  @begin{short}
    Gets the child of the @class{gtk-bin}, or @code{nil} if the bin contains no
    child widget.
  @end{short}
  The returned widget does not have a reference added, so you do not need to
  unref it."
  (bin (g-object gtk-bin)))

(export 'gtk-bin-get-child)

;;; --- End of file gtk.bin.lisp -----------------------------------------------
