;;; ----------------------------------------------------------------------------
;;; gobject.g-value.lisp
;;;
;;; This file contains code from a fork of cl-gtk2.
;;; See http://common-lisp.net/project/cl-gtk2/
;;;
;;; The documentation of this file has been copied from the
;;; GObject Reference Manual Version 2.32.4. See http://www.gtk.org
;;;
;;; Copyright (C) 2009 - 2011 Kalyanov Dmitry
;;; Copyright (C) 2011 - 2012 Dieter Kaiser
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

(in-package :gobject)

;;; ----------------------------------------------------------------------------

;; A generic function for getting the value of a g-value structure.

(defgeneric parse-g-value-for-type (gvalue-ptr gtype parse-kind))

(defmethod parse-g-value-for-type :around (gvalue-ptr gtype parse-kind)
  (assert (typep gtype '(or gtype nil)))
  (call-next-method))

(defmethod parse-g-value-for-type (gvalue-ptr gtype parse-kind)
  (if (eq gtype (g-type-fundamental gtype))
      (call-next-method)
      (parse-g-value-for-type gvalue-ptr
                              (g-type-fundamental gtype)
                              parse-kind)))

(defmethod parse-g-value-for-type (gvalue-ptr
                                   (type (eql (gtype +g-type-pointer+)))
                                   parse-kind)
  (declare (ignore parse-kind))
  (g-value-get-pointer gvalue-ptr))

(defmethod parse-g-value-for-type (gvalue-ptr
                                   (type (eql (gtype +g-type-param+)))
                                   parse-kind)
  (declare (ignore parse-kind))
  (parse-g-param-spec (g-value-get-param gvalue-ptr)))

(defmethod parse-g-value-for-type (gvalue-ptr
                                   (type (eql (gtype +g-type-object+)))
                                   parse-kind)
  (declare (ignore parse-kind))
  (g-value-get-object gvalue-ptr))

(defmethod parse-g-value-for-type (gvalue-ptr
                                   (type (eql (gtype +g-type-interface+)))
                                   parse-kind)
  (declare (ignore parse-kind))
  (g-value-get-object gvalue-ptr))

;;; ----------------------------------------------------------------------------
;;; parse-g-value (gvalue parse-kind)
;;;
;;; Parses the g-value structure and returns the corresponding Lisp object.
;;; This is a more general function which replaces the functions g-value-get-...
;;; The function is not part of the GObject library.
;;;
;;; Note:
;;;     It might be more consistent to name this function like the
;;;     corresponding functions as g-value-get ()
;;;
;;; value :
;;;     a C pointer to the GValue structure
;;;
;;; return :
;;;     value contained in the GValue structure. Type of value depends
;;;     on GValue type
;;; ----------------------------------------------------------------------------

(defun parse-g-value (gvalue &key (parse-kind :get-property))
  (let* ((gtype (g-value-type gvalue))
         (fundamental-type (g-type-fundamental gtype)))
    (ev-case fundamental-type
      ((gtype +g-type-invalid+)
       (error "GValue is of invalid type (~A)" (gtype-name gtype)))
      ((gtype +g-type-void+) nil)
      ((gtype +g-type-char+) (g-value-get-char gvalue))
      ((gtype +g-type-uchar+) (g-value-get-uchar gvalue))
      ((gtype +g-type-boolean+) (g-value-get-boolean gvalue))
      ((gtype +g-type-int+) (g-value-get-int gvalue))
      ((gtype +g-type-uint+) (g-value-get-uint gvalue))
      ((gtype +g-type-long+) (g-value-get-long gvalue))
      ((gtype +g-type-ulong+) (g-value-get-ulong gvalue))
      ((gtype +g-type-int64+) (g-value-get-int64 gvalue))
      ((gtype +g-type-uint64+) (g-value-get-uint64 gvalue))
      ((gtype +g-type-enum+) (parse-g-value-enum gvalue))
      ((gtype +g-type-flags+) (parse-g-value-flags gvalue))
      ((gtype +g-type-float+) (g-value-get-float gvalue))
      ((gtype +g-type-double+) (g-value-get-double gvalue))
      ((gtype +g-type-string+) (g-value-get-string gvalue))
      ((gtype +g-type-variant+) (g-value-get-variant gvalue))
      (t (parse-g-value-for-type gvalue gtype parse-kind)))))

;;; ----------------------------------------------------------------------------

;;; A generic function for setting the value of a GValue structure.

(defgeneric set-gvalue-for-type (gvalue-ptr type value))

(defmethod set-gvalue-for-type :around (gvalue-ptr type value)
  (assert (typep type '(or gtype null)))
  (call-next-method))

(defmethod set-gvalue-for-type (gvalue-ptr type value)
  (if (eq type (g-type-fundamental type))
      (call-next-method)
      (set-gvalue-for-type gvalue-ptr (g-type-fundamental type) value)))

(defmethod set-gvalue-for-type (gvalue-ptr
                                (type (eql (gtype +g-type-pointer+)))
                                value)
  (g-value-set-pointer gvalue-ptr value))

(defmethod set-gvalue-for-type (gvalue-ptr
                                (type (eql (gtype +g-type-param+)))
                                value)
  (declare (ignore gvalue-ptr value))
  (error "Setting of GParam is not implemented"))

(defmethod set-gvalue-for-type (gvalue-ptr
                                (type (eql (gtype +g-type-object+)))
                                value)
  (g-value-set-object gvalue-ptr value))

(defmethod set-gvalue-for-type (gvalue-ptr
                                (type (eql (gtype +g-type-interface+)))
                                value)
  (g-value-set-object gvalue-ptr value))

;;; ----------------------------------------------------------------------------
;;; set-g-value (gvalue value type zero-g-value unset-g-value g-value-init)
;;;
;;; Assigns the GValue structure gvalue the value value of GType type. This is
;;; a more general function which replaces the functions g-value-set-...
;;; The function is not part of the GObject library.
;;;
;;; Note :
;;;     It might be more consistent to name this function like the
;;;     corresponding functions as g-value-set ()
;;;
;;; gvalue :
;;;     a C pointer to the GValue structure
;;;
;;; value :
;;;     a Lisp object that is to be assigned
;;;
;;; type :
;;;     a GType that is to be assigned
;;;
;;; zero-g-value :
;;;     a boolean specifying whether GValue should be zero-initialized before
;;;     assigning. See g-value-zero.
;;;
;;; unset-g-value :
;;;     a boolean specifying whether GValue should be 'unset' before assigning.
;;;     See g-value-unset. The 'true' value should not be passed to both
;;;     zero-g-value and unset-g-value arguments
;;;
;;; g-value-init :
;;;     a boolean specifying where GValue should be initialized
;;; ----------------------------------------------------------------------------

(defun set-g-value (gvalue value type &key zero-g-value
                                           unset-g-value
                                           (g-value-init t))
  (setf type (gtype type))
  (cond (zero-g-value (g-value-zero gvalue))
        (unset-g-value (g-value-unset gvalue)))
  (when g-value-init (g-value-init gvalue type))
  (let ((fundamental-type (g-type-fundamental type)))
    (ev-case fundamental-type
      ((gtype +g-type-invalid+) (error "Invalid type (~A)" type))
      ((gtype +g-type-void+) nil)
      ((gtype +g-type-char+) (g-value-set-char gvalue value))
      ((gtype +g-type-uchar+) (g-value-set-uchar gvalue value))
      ((gtype +g-type-boolean+) (g-value-set-boolean gvalue value))
      ((gtype +g-type-int+) (g-value-set-int gvalue value))
      ((gtype +g-type-uint+) (g-value-set-uint gvalue value))
      ((gtype +g-type-long+) (g-value-set-long gvalue value))
      ((gtype +g-type-ulong+) (g-value-set-ulong gvalue value))
      ((gtype +g-type-int64+) (g-value-set-int64 gvalue value))
      ((gtype +g-type-uint64+) (g-value-set-uint64 gvalue value))
      ((gtype +g-type-enum+) (set-gvalue-enum gvalue value))
      ((gtype +g-type-flags+) (set-gvalue-flags gvalue value))
      ((gtype +g-type-float+)
       (unless (realp value) (error "~A is not a real number" value))
       (g-value-set-float gvalue (coerce value 'single-float)))
      ((gtype +g-type-double+)
       (unless (realp value) (error "~A is not a real number" value))
       (g-value-set-double gvalue (coerce value 'double-float)))
      ((gtype +g-type-string+) (g-value-set-string gvalue value))
      ((gtype +g-type-variant+) (g-value-set-variant gvalue value))
      (t (set-gvalue-for-type gvalue type value)))))

;;; ----------------------------------------------------------------------------
;;; GValue
;;; ----------------------------------------------------------------------------

(defcunion g-value-data
  (:int :int)
  (:uint :uint)
  (:long :long)
  (:ulong :ulong)
  (:int64 :int64)
  (:uint64 :uint64)
  (:float :float)
  (:double :double)
  (:pointer :pointer))

;;; ----------------------------------------------------------------------------

(defcstruct g-value
  (:type g-type)
  (:data g-value-data :count 2))

(export 'g-value)

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'g-value atdoc:*symbol-name-alias*) "CStruct"
      (gethash 'g-value atdoc:*external-symbols*)
 "@version{2013-2-6}
  @begin{short}
    The @sym{g-value} structure is basically a variable container that consists
    of a type identifier and a specific value of that type. The type identifier
    within a @sym{g-value} structure always determines the type of the
    associated value.
  @end{short}
  To create a undefined @sym{g-value} structure, simply create a zero-filled
  @sym{g-value} structure. To initialize the @sym{g-value}, use the
  @fun{g-value-init} function. A @sym{g-value} cannot be used until it is
  initialized. The basic type operations (such as freeing and copying) are
  determined by the @symbol{g-type-value-table} associated with the type ID
  stored in the @sym{g-value}. Other @sym{g-value} operations (such as
  converting values between types) are provided by this interface.

  The code in the example program below demonstrates @sym{g-value}'s features.
  @begin{pre}
;; A transformation from an integer to a string
(defcallback int2string :void ((src-value (:pointer g-value))
                               (dest-value (:pointer g-value)))
  (if (eql (g-value-get-int src-value) 42)
      (g-value-set-string dest-value \"An important number\")
      (g-value-set-string dest-value \"What is that?\")))

(defun example-g-value ()
  ;; Declare two variables of type g-value.
  (with-foreign-objects ((value1 'g-value) (value2 'g-value))
    
    ;; Initialization, setting and reading a value of type g-value
    (g-value-init value1 +g-type-string+)
    (g-value-set-string value1 \"string\")
    (format t \"value1 = ~A~%\" (g-value-get-string value1))
    (format t \"type   = ~A~%\" (g-value-type value1))
    (format t \"name   = ~A~%~%\" (g-value-type-name value1))
    
    ;; The same in one step with the Lisp extension set-g-value
    (set-g-value value2 \"a second string\" +g-type-string+ :zero-g-value t)
    (format t \"value2 = ~A~%\" (parse-g-value value2))
    (format t \"type   = ~A~%\" (g-value-type value2))
    (format t \"name   = ~A~%~%\" (g-value-type-name value2))
    
    ;; Reuse value1 for an integer value.
    (g-value-unset value1)
    (g-value-init value1 +g-type-int+)
    (g-value-set-int value1 42)
    (format t \"value1 = ~A~%\" (parse-g-value value1))
    (format t \"type   = ~A~%\" (g-value-type value1))
    (format t \"name   = ~A~%~%\" (g-value-type-name value1))
    
    ;; The types integer and string are transformable.
    (assert (g-value-type-transformable +g-type-int+ +g-type-string+))
    
    ;; Transform value1 of type integer into value2 which is a string
    (g-value-transform value1 value2)
    (format t \"value1 = ~A~%\" (parse-g-value value1))
    (format t \"value2 = ~A~%~%\" (parse-g-value value2))
    
    ;; Some test functions.
    (assert (g-value-holds value1 +g-type-int+))
    (format t \"value-holds is ~A~%\" (g-value-holds value1 +g-type-int+))
    (format t \"is-value is ~A~%~%\" (g-type-is-value +g-type-int+))
                             
    ;; Reuse value2 again for a string.
    (g-value-unset value2)
    (g-value-init value2 +g-type-string+)
    (g-value-set-string value2 \"string\")
    (format t \"value2 = ~A~%\" (parse-g-value value2))
    
    ;; Register the transformation int2string
    (g-value-register-transform-func +g-type-int+
                                     +g-type-string+
                                     (callback int2string))
    ;; Try the transformation
    (g-value-transform value1 value2)
    (format t \"value2 = ~A~%~%\" (parse-g-value value2))))
  @end{pre}
  The data within the @sym{g-value} structure has protected scope: it is
  accessible only to functions within a @symbol{g-type-value-table} structure,
  or implementations of the @sym{g-value-*} API. That is, code portions which
  implement new fundamental types. @sym{g-value} users cannot make any
  assumptions about how data is stored within the 2 element data union, and the
  @class{g-type} member should only be accessed through the @fun{g-value-type}
  function.")

;;; ----------------------------------------------------------------------------
;;; G_VALUE_INIT
;;;
;;; #define G_VALUE_INIT  { 0, { { 0 } } }
;;;
;;; A GValue must be initialized before it can be used. This macro can be used
;;; as initializer instead of an explicit { 0 } when declaring a variable, but
;;; it cannot be assigned to a variable.
;;;
;;;   GValue value = G_VALUE_INIT;
;;;
;;; Since 2.30
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; G_VALUE_HOLDS()
;;; ----------------------------------------------------------------------------

(defun g-value-holds (value gtype)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[value]{A @symbol{g-value} structure.}
  @argument[type]{A @class{g-type} value.}
  @return{@arg{true} if @arg{value} holds the @arg{type}.}
  @begin{short}
    Checks if @arg{value} holds (or contains) a value of @arg{type}. This
    function will also check for a value @code{nil} and issue a warning if the
    check fails.
  @end{short}"
  (g-type= gtype (g-value-type value)))

(export 'g-value-holds)

;;; ----------------------------------------------------------------------------
;;; G_VALUE_TYPE()
;;; ----------------------------------------------------------------------------

(defun g-value-type (value)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[value]{A @symbol{g-value} structure.}
  @return{the @class{g-type}.}
  @begin{short}
    Get the type identifier of value.
  @end{short}"
  (foreign-slot-value value 'g-value :type))

(export 'g-value-type)

;;; ----------------------------------------------------------------------------
;;; G_VALUE_TYPE_NAME()
;;; ----------------------------------------------------------------------------

(defun g-value-type-name (value)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[value]{A @smybol{g-value} structure.}
  @return{The type name of @arg{value}.}
  @begin{short}
    Gets the the type name of @arg{value}.
  @end{short}"
  (gtype-name (g-value-type value)))

(export 'g-value-type-name)

;;; ----------------------------------------------------------------------------
;;; G_TYPE_IS_VALUE()
;;; ----------------------------------------------------------------------------

(defun g-type-is-value (gtype)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[type]{A @class{g-type} value.}
  @return{Whether @arg{type} is suitable as a @symbol{g-value} type.}
  @begin{short}
    Checks whether the passed in type ID can be used for @fun{g-value-init}.
  @end{short}
  That is, this function checks whether this @arg{type} provides an
  implementation of the @symbol{g-type-value-table} functions required for a
  type to create a @symbol{g-value} of."
  (g-type-check-is-value-type gtype))

(export 'g-type-is-value)

;;; ----------------------------------------------------------------------------
;;; G_TYPE_IS_VALUE_ABSTRACT()
;;;
;;; #define G_TYPE_IS_VALUE_ABSTRACT(type)
;;;         (g_type_test_flags ((type), G_TYPE_FLAG_VALUE_ABSTRACT))
;;;
;;; Checks if type is an abstract value type. An abstract value type introduces
;;; a value table, but can't be used for g_value_init() and is normally used as
;;; an abstract base type for derived value types.
;;;
;;; type :
;;;     A GType value.
;;;
;;; Returns :
;;;     TRUE on success.
;;; ----------------------------------------------------------------------------

(defun g-type-is-value-abstract (gtype)
  (g-type-test-flags gtype :value-abstract))

(export 'g-type-is-value-abstract)

;;; ----------------------------------------------------------------------------
;;; G_IS_VALUE()
;;;
;;; #define G_IS_VALUE(value) (G_TYPE_CHECK_VALUE (value))
;;;
;;; Checks if value is a valid and initialized GValue structure.
;;;
;;; value :
;;;     A GValue structure.
;;;
;;; Returns :
;;;     TRUE on success.
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; G_TYPE_VALUE
;;;
;;; #define G_TYPE_VALUE (g_value_get_type ())
;;;
;;; The type ID of the "GValue" type which is a boxed type, used to pass around
;;; pointers to GValues.
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; G_TYPE_VALUE_ARRAY
;;;
;;; #define G_TYPE_VALUE_ARRAY (g_value_array_get_type ())
;;;
;;; Warning
;;;
;;; G_TYPE_VALUE_ARRAY has been deprecated since version 2.32 and should not be
;;; used in newly-written code. Use GArray instead of GValueArray
;;;
;;; The type ID of the "GValueArray" type which is a boxed type, used to pass
;;; around pointers to GValueArrays.
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; g_value_init ()
;;; ----------------------------------------------------------------------------

(defcfun ("g_value_init" %g-value-init) (:pointer g-value)
  (value (:pointer g-value))
  (gtype g-type))

;; Initializes the GValue in 'unset' state.
;; This function is called from g-value-init to initialize the GValue
;; structure with zeros. value is a C pointer to the GValue structure.

(defun g-value-zero (value)
  (loop
     for i from 0 below (foreign-type-size 'g-value)
     do (setf (mem-ref value :uchar i) 0)))

(export 'g-value-zero)

(defun g-value-init (value &optional (type nil))
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[value]{A zero-filled (uninitialized) GValue structure.}
  @argument[g_type]{Type the GValue should hold values of.}
  @return{the GValue structure that has been passed in}
  @begin{short}
    Initializes value with the default value of type.
  @end{short}"
  (cond ((null type)
         (g-value-zero value))
        (t
         (g-value-zero value)
         (%g-value-init value type)))
  value)

(export 'g-value-init)

;;; ----------------------------------------------------------------------------
;;; g_value_copy ()
;;; ----------------------------------------------------------------------------

(defcfun ("g_value_copy" g-value-copy) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[src_value]{An initialized GValue structure.}
  @argument[dest_value]{An initialized GValue structure of the same type as
    src_value.}
  @begin{short}
    Copies the value of src_value into dest_value.
  @end{short}"
  (src-value (:pointer g-value))
  (dst-value (:pointer g-value)))

(export 'g-value-copy)

;;; ----------------------------------------------------------------------------
;;; g_value_reset ()
;;; ----------------------------------------------------------------------------

(defcfun ("g_value_reset" g-value-reset) (:pointer g-value)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[value]{An initialized GValue structure.}
  @return{the GValue structure that has been passed in}
  @begin{short}
    Clears the current value in value and resets it to the default value (as if
    the value had just been initialized).
  @end{short}"
  (value (:pointer g-value)))

(export 'g-value-reset)

;;; ----------------------------------------------------------------------------
;;; g_value_unset ()
;;; ----------------------------------------------------------------------------

(defcfun ("g_value_unset" g-value-unset) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[value]{An initialized GValue structure.}
  @begin{short}
    Clears the current value in value and \"unsets\" the type, this releases all
    resources associated with this GValue.
  @end{short}
  An unset value is the same as an uninitialized (zero-filled) GValue
  structure."
  (value (:pointer g-value)))

(export 'g-value-unset)

;;; ----------------------------------------------------------------------------
;;; g_value_set_instance ()
;;; ----------------------------------------------------------------------------

(defcfun ("g_value_set_instance" g-value-set-instance) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[value]{An initialized GValue structure.}
  @argument[instance]{the instance}
  @begin{short}
    Sets value from an instantiatable type via the value_table's collect_value()
    function.
  @end{short}"
  (value (:pointer g-value))
  (instance :pointer))

(export 'g-value-set-instance)

;;; ----------------------------------------------------------------------------
;;; g_value_fits_pointer ()
;;;
;;; gboolean g_value_fits_pointer (const GValue *value);
;;;
;;; Determines if value will fit inside the size of a pointer value. This is an
;;; internal function introduced mainly for C marshallers.
;;;
;;; value :
;;;     An initialized GValue structure.
;;;
;;; Returns :
;;;     TRUE if value will fit inside a pointer value.
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; g_value_peek_pointer ()
;;;
;;; gpointer g_value_peek_pointer (const GValue *value);
;;;
;;; value :
;;;     An initialized GValue structure.
;;;
;;; Returns :
;;;     the value contents as pointer. This function asserts that
;;;     g_value_fits_pointer() returned TRUE for the passed in value. This is an
;;;     internal function introduced mainly for C marshallers.
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; g_value_type_compatible ()
;;; ----------------------------------------------------------------------------

(defcfun ("g_value_type_compatible" g-value-type-compatible) :boolean
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[src_type]{source type to be copied.}
  @argument[dest_type]{destination type for copying.}
  @return{@arg{true} if g_value_copy() is possible with src_type and dest_type.}
  @begin{short}
    Returns whether a GValue of type src_type can be copied into a GValue of
    type dest_type.
  @end{short}"
  (src-type g-type)
  (dest-type g-type))

(export 'g-value-type-compatible)

;;; ----------------------------------------------------------------------------
;;; g_value_type_transformable ()
;;; ----------------------------------------------------------------------------

(defcfun ("g_value_type_transformable" g-value-type-transformable) :boolean
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[src_type]{Source type.}
  @argument[dest_type]{Target type.}
  @return{@code{nil} if the transformation is possible, @code{nil} otherwise.}
  @begin{short}
    Check whether g_value_transform() is able to transform values of type
    src_type into values of type dest_type.
  @end{short}"
  (src-type g-type)
  (dest-type g-type))

(export 'g-value-type-transformable)

;;; ----------------------------------------------------------------------------
;;; g_value_transform ()
;;; ----------------------------------------------------------------------------

(defcfun ("g_value_transform" g-value-transform) :boolean
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[src_value]{Source value.}
  @argument[dest_value]{Target value.}
  @return{Whether a transformation rule was found and could be applied. Upon
    failing transformations, dest_value is left untouched.}
  @begin{short}
    Tries to cast the contents of src_value into a type appropriate to store in
    dest_value, e.g. to transform a G_TYPE_INT value into a G_TYPE_FLOAT value.
  @end{short}
  Performing transformations between value types might incur precision
  lossage. Especially transformations into strings might reveal seemingly
  arbitrary results and shouldn't be relied upon for production code (such as
  rcfile value or object property serialization)."
  (src-value (:pointer g-value))
  (dest-value (:pointer g-value)))

(export 'g-value-transform)

;;; ----------------------------------------------------------------------------
;;; GValueTransform ()
;;;
;;; void (*GValueTransform) (const GValue *src_value, GValue *dest_value);
;;;
;;; The type of value transformation functions which can be registered with
;;; g_value_register_transform_func().
;;;
;;; src_value :
;;;     Source value.
;;;
;;; dest_value :
;;;     Target value.
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; g_value_register_transform_func ()
;;; ----------------------------------------------------------------------------

(defcfun ("g_value_register_transform_func" g-value-register-transform-func)
    :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[src_type]{Source type.}
  @argument[dest_type]{Target type.}
  @argument[transform_func]{a function which transforms values of type src_type
    into value of type dest_type}
  @begin{short}
    Registers a value transformation function for use in g_value_transform().
  @end{short}
  A previously registered transformation function for src_type and dest_type
  will be replaced."
  (src-type g-type)
  (dest-type g-type)
  (transform-func :pointer))

(export 'g-value-register-transform-func)

;;; ----------------------------------------------------------------------------
;;; g_strdup_value_contents ()
;;; ----------------------------------------------------------------------------

(defcfun ("g_strdup_value_contents" g-strdup-value-contents) :string
 #+cl-cffi-gtk-documentation
 "@version{2013-2-6}
  @argument[value]{GValue which contents are to be described.}
  @return{Newly allocated string.}
  @begin{short}
    Return a newly allocated string, which describes the contents of a GValue.
  @end{short}
  The main purpose of this function is to describe GValue contents for
  debugging output, the way in which the contents are described may change
  between different GLib versions."
  (value (:pointer g-value)))

(export 'g-strdup-value-contents)

;;; --- End of file gobject.g-value.lisp ---------------------------------------
