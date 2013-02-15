;;; ----------------------------------------------------------------------------
;;; gtk.action.lisp
;;;
;;; This file contains code from a fork of cl-gtk2.
;;; See http://common-lisp.net/project/cl-gtk2/
;;;
;;; The documentation has been copied from the GTK+ 3 Reference Manual
;;; Version 3.4.3. See http://www.gtk.org.
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
;;;    GtkAction
;;;
;;;    An action which can be triggered by a menu or toolbar item
;;;
;;;    Synopsis
;;;
;;;    GtkAction
;;;
;;;    gtk_action_new
;;;    gtk_action_get_name
;;;    gtk_action_is_sensitive
;;;    gtk_action_get_sensitive
;;;    gtk_action_set_sensitive
;;;    gtk_action_is_visible
;;;    gtk_action_get_visible
;;;    gtk_action_set_visible
;;;    gtk_action_activate
;;;    gtk_action_create_icon
;;;    gtk_action_create_menu_item
;;;    gtk_action_create_tool_item
;;;    gtk_action_create_menu
;;;    gtk_action_get_proxies
;;;    gtk_action_connect_accelerator
;;;    gtk_action_disconnect_accelerator
;;;    gtk_action_block_activate
;;;    gtk_action_unblock_activate
;;;    gtk_action_get_always_show_image
;;;    gtk_action_set_always_show_image
;;;    gtk_action_get_accel_path
;;;    gtk_action_set_accel_path
;;;    gtk_action_get_accel_closure
;;;    gtk_action_set_accel_group
;;;    gtk_action_set_label
;;;    gtk_action_get_label
;;;    gtk_action_set_short_label
;;;    gtk_action_get_short_label
;;;    gtk_action_set_tooltip
;;;    gtk_action_get_tooltip
;;;    gtk_action_set_stock_id
;;;    gtk_action_get_stock_id
;;;    gtk_action_set_gicon
;;;    gtk_action_get_gicon
;;;    gtk_action_set_icon_name
;;;    gtk_action_get_icon_name
;;;    gtk_action_set_visible_horizontal
;;;    gtk_action_get_visible_horizontal
;;;    gtk_action_set_visible_vertical
;;;    gtk_action_get_visible_vertical
;;;    gtk_action_set_is_important
;;;    gtk_action_get_is_important
;;; ----------------------------------------------------------------------------

(in-package :gtk)

;;; ----------------------------------------------------------------------------
;;; Class GtkAction
;;; ----------------------------------------------------------------------------

(define-g-object-class "GtkAction" gtk-action
  (:superclass g-object
    :export t
    :interfaces ("GtkBuildable")
    :type-initializer "gtk_action_get_type")
  ((action-group
    gtk-action-action-group
    "action-group" "GtkActionGroup" t t)
   (always-show-image
    gtk-action-always-show-image
    "always-show-image" "gboolean" t t)
   (gicon
    gtk-action-gicon
    "gicon" "GIcon" t t)
   (hide-if-empty
    gtk-action-hide-if-empty
    "hide-if-empty" "gboolean" t t)
   (icon-name
    gtk-action-icon-name
    "icon-name" "gchararray" t t)
   (is-important
    gtk-action-is-important
    "is-important" "gboolean" t t)
   (label
    gtk-action-label
    "label" "gchararray" t t)
   (name
    gtk-action-name
    "name" "gchararray" t nil)
   (sensitive
    gtk-action-sensitive
    "sensitive" "gboolean" t t)
   (short-label
    gtk-action-short-label
    "short-label" "gchararray" t t)
   (stock-id
    gtk-action-stock-id
    "stock-id" "gchararray" t t)
   (tooltip
    gtk-action-tooltip
    "tooltip" "gchararray" t t)
   (visible
    gtk-action-visible
    "visible" "gboolean" t t)
   (visible-horizontal
    gtk-action-visible-horizontal
    "visible-horizontal" "gboolean" t t)
   (visible-overflown
    gtk-action-visible-overflown
    "visible-overflown" "gboolean" t t)
   (visible-vertical
    gtk-action-visible-vertical
    "visible-vertical" "gboolean" t t)))

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation 'gtk-action 'type)
 "@version{2013-2-5}
  @begin{short}
    Actions represent operations that the user can be perform, along with some
    information how it should be presented in the interface. Each action
    provides methods to create icons, menu items and toolbar items representing
    itself.
  @end{short}

  As well as the callback that is called when the action gets activated, the
  following also gets associated with the action:
  @begin{itemize}
    @item{a name (not translated, for path lookup)}
    @item{a label (translated, for display)}
    @item{an accelerator}
    @item{whether label indicates a stock id}
    @item{a tooltip (optional, translated)}
    @item{a toolbar label (optional, shorter than label)}
  @end{itemize}
  The action will also have some state information:
  @begin{itemize}
    @item{visible (shown/hidden)}
    @item{sensitive (enabled/disabled)}
  @end{itemize}
  Apart from regular actions, there are toggle actions, which can be toggled
  between two states and radio actions, of which only one in a group can be in
  the \"active\" state. Other actions can be implemented as @sym{gtk-action}
  subclasses.

  Each action can have one or more proxy widgets. To act as an action proxy,
  widget needs to implement @class{gtk-activatable} interface. Proxies mirror
  the state of the action and should change when the action's state changes.
  Properties that are always mirrored by proxies are \"sensitive\" and
  \"visible\". \"gicon\", \"icon-name\", \"label\", \"short-label\" and
  \"stock-id\" properties are only mirorred if proxy widget has
  \"use-action-appearance\" property set to @arg{true}.

  When the proxy is activated, it should activate its action.
  @begin[Signal Details]{dictionary}
    @subheading{The \"activate\" signal}
      The \"activate\" signal is emitted when the action is activated.
      @begin{pre}
 void user_function (GtkAction *action,
                     gpointer   user_data)      : No Recursion
      @end{pre}
      @begin[code]{table}
        @entry[action]{the @sym{gtk-action}}
        @entry[user_data]{user data set when the signal handler was connected.}
      @end{table}
      Since 2.4
  @end{dictionary}
  @see-slot{gtk-action-action-group}
  @see-slot{gtk-action-always-show-image}
  @see-slot{gtk-action-gicon}
  @see-slot{gtk-action-hide-if-empty}
  @see-slot{gtk-action-icon-name}
  @see-slot{gtk-action-is-important}
  @see-slot{gtk-action-label}
  @see-slot{gtk-action-name}
  @see-slot{gtk-action-sensitive}
  @see-slot{gtk-action-short-label}
  @see-slot{gtk-action-stock-id}
  @see-slot{gtk-action-tooltip}
  @see-slot{gtk-action-visible}
  @see-slot{gtk-action-visible-horizontal}
  @see-slot{gtk-action-visible-overflown}
  @see-slot{gtk-action-visible-vertical}
")

;;; ----------------------------------------------------------------------------
;;;
;;; Property Details
;;;
;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "action-group" 'gtk-action) 't)
 "The @code{\"action-group\"} property of type @class{gtk-action-group}
  (Read / Write)@br{}
  The @class{gtk-action-group} this @sym{gtk-action} is associated with, or
  @code{nil} (for internal use).")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "always-show-image" 'gtk-action) 't)
 "The @code{\"always-show-image\"} property of type @code{gboolean}
  (Read / Write / Construct)@br{}
  If @arg{true}, the action's menu item proxies will ignore the
  @code{\"gtk-menu-images\"} setting and always show their image, if available.
  Use this property if the menu item would be useless or hard to use without
  their image.@br{}
  Default value: @code{nil}@br{}
  Since 2.20")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "gicon" 'gtk-action) 't)
 "The @code{\"gicon\"} property of type @code{GIcon*} (Read / Write)@br{}
  The GIcon displayed in the GtkAction.
  Note that the stock icon is preferred, if the \"stock-id\" property holds the
  id of an existing stock icon.
  This is an appearance property and thus only applies if
  \"use-action-appearance\" is @arg{true}.@br{}
  Since 2.16")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "hide-if-empty" 'gtk-action) 't)
 "The @code{\"hide-if-empty\"} property of type @code{gboolean}
  (Read / Write)@br{}
  When @arg{true}, empty menu proxies for this action are hidden.@br{}
  Default value: @arg{true}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "icon-name" 'gtk-action) 't)
 "The @code{\"icon-name\"} property of type @code{gchar*} (Read / Write)@br{}
  The name of the icon from the icon theme.
  Note that the stock icon is preferred, if the @code{\"stock-id\"} property
  holds the id of an existing stock icon, and the @code{GIcon} is preferred if
  the @code{\"gicon\"} property is set.
  This is an appearance property and thus only applies if
  @code{\"use-action-appearance\"} is @arg{true}.@br{}
  Default value: @code{nil}@br{}
  Since 2.10")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "is-important" 'gtk-action) 't)
 "The @code{\"is-important\"} property of type @code{gboolean}
  (Read / Write)@br{}
  Whether the action is considered important. When @arg{true}, toolitem proxies
  for this action show text in @code{GTK_TOOLBAR_BOTH_HORIZ} mode.@br{}
  Default value: @code{nil}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "label" 'gtk-action) 't)
 "The @code{\"label\"} property of type @code{gchar*} (Read / Write)@br{}
  The label used for menu items and buttons that activate this action. If the
  label is @code{nil}, GTK+ uses the stock label specified via the
  @code{\"stock-id\"} property.
  This is an appearance property and thus only applies if
  \"use-action-appearance\" is @arg{true}.@br{}
  Default value: @code{nil}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "name" 'gtk-action) 't)
 "The @code{\"name\"} property of type @code{gchar*}
  (Read / Write / Construct)@br{}
  A unique name for the action.@br{}
  Default value: @code{nil}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "sensitive" 'gtk-action) 't)
 "The @code{\"sensitive\"} property of type @code{gboolean} (Read / Write)@br{}
  Whether the action is enabled.@br{}
  Default value: @arg{true}")
;;;
;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "short-label" 'gtk-action) 't)
 "The @code{\"short-label\"} property of type @code{gchar*} (Read / Write)@br{}
  A shorter label that may be used on toolbar buttons.
  This is an appearance property and thus only applies if
  \"use-action-appearance\" is @arg{true}.@br{}
  Default value: @code{nil}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "stock-id" 'gtk-action) 't)
 "The @code{\"stock-id\"} property of type @code{gchar*} (Read / Write)@br{}
  The stock icon displayed in widgets representing this action.
  This is an appearance property and thus only applies if
  \"use-action-appearance\" is @arg{true}.@br{}
  Default value: @code{nil}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "tooltip" 'gtk-action) 't)
 "The @code{\"tooltip\"} property of type @code{gchar*} (Read / Write)@br{}
  A tooltip for this action.@br{}
  Default value: @code{nil}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "visible" 'gtk-action) 't)
 "The @code{\"visible\"} property of type  @code{gboolean} (Read / Write)@br{}
  Whether the action is visible.@br{}
  Default value: @arg{true}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "visible-horizontal" 'gtk-action) 't)
 "The @code{\"visible-horizontal\"} property of type @code{gboolean}
  (Read / Write)@br{}
  Whether the toolbar item is visible when the toolbar is in a horizontal
  orientation.@br{}
  Default value: @arg{true}")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "visible-overflown" 'gtk-action) 't)
 "The @code{\"visible-overflown\"} property of type @code{gboolean}
  (Read / Write)@br{}
  When @arg{true}, toolitem proxies for this action are represented in the
  toolbar overflow menu.@br{}
  Default value: @arg{true}@br{}
  Since 2.6")

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "visible-vertical" 'gtk-action) 't)
 "The @code{\"visible-vertical\"} property of type @code{gboolean}
  (Read / Write)@br{}
  Whether the toolbar item is visible when the toolbar is in a vertical
  orientation.@br{}
  Default value: @arg{true}")

;;; ----------------------------------------------------------------------------
;;;
;;; Accessors
;;;
;;; ----------------------------------------------------------------------------

;;; --- gtk-action-action-group ------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-action-group atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-action-group 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"action-group\"} of the @class{gtk-action}
    class.
  @end{short}")

;;; --- gtk-action-always-show-image -------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-always-show-image atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-always-show-image 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"always-show-image\"} of the @class{gtk-action}
    class.
  @end{short}")

;;; --- gtk-action-gicon -------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-gicon atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-gicon 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"gicon\"} of the @class{gtk-action}
    class.
  @end{short}")

;;; --- gtk-action-hide-if-empty -----------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-hide-if-empty atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-hide-if-empty 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"hide-if-empty\"} of the @class{gtk-action}
    class.
  @end{short}")

;;; --- gtk-action-icon-name ---------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-icon-name atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-icon-name 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"icon-name\"} of the @class{gtk-action}
    class.
  @end{short}")

;;; --- gtk-action-is-important ------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-is-important atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-is-important 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"is-important\"} of the @class{gtk-action}
    class.
  @end{short}")

;;; --- gtk-action-label -------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-label atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-label 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"label\"} of the @class{gtk-action} class.
  @end{short}")

;;; --- gtk-action-name --------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-name atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-name 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"name\"} of the @class{gtk-action} class.
  @end{short}")

;;; --- gtk-action-sensitive ---------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-sensitive atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-sensitive 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"senstive\"} of the @class{gtk-action} class.
  @end{short}")

;;; --- gtk-action-short-label -------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-short-label atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-short-label 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"short-label\"} of the @class{gtk-action} class.
  @end{short}")

;;; --- gtk-action-stock-id ----------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-stock-id atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-stock-id 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"stock-id\"} of the @class{gtk-action} class.
  @end{short}")

;;; --- gtk-action-tooltip -----------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-tooltip atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-tooltip 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"tooltip\"} of the @class{gtk-action} class.
  @end{short}")

;;; --- gtk-action-visible -----------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-visible atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-visible 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"visible\"} of the @class{gtk-action} class.
  @end{short}")

;;; --- gtk-action-visible-horizontal ------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-visible-horizontal atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-visible-horizontal 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"visible-horizontal\"} of the @class{gtk-action}
    class.
  @end{short}")

;;; --- gtk-action-visible-overflown -------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-visible-overflown atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-visible-overflown 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"visible-overflown\"} of the @class{gtk-action}
    class.
  @end{short}")

;;; --- gtk-action-visible-vertical --------------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-action-visible-vertical atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-action-visible-vertical 'function)
 "@version{2013-2-9}
  @begin{short}
    Accessor of the slot @code{\"visible-vertical\"} of the @class{gtk-action}
    class.
  @end{short}")

;;; ----------------------------------------------------------------------------
;;; gtk_action_new ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-action-new))

(defun gtk-action-new (name label tooltip stock-id)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[name]{A unique name for the action.}
  @argument[label]{the label displayed in menu items and on buttons,
    or @code{nil}}
  @argument[tooltip]{a tooltip for the action, or @code{nil}}
  @argument[stock-id]{the stock icon to display in widgets representing the
    action, or @code{nil}}
  @return{A new @class{gtk-action object}.}
  @begin{short}
    Creates a new @class{gtk-action} object.
  @end{short}
  To add the action to a @class{gtk-action-group} and set the accelerator for
  the action, call @fun{gtk-action-group-add-action-with-accel}. See the section
  called UI Definitions for information on allowed action names.

  Since 2.4"
  (make-instance 'gtk-action
                 :name name
                 :label label
                 :tooltip tooltip
                 :stock-id stock-id))

(export 'gtk-action-new)

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_name ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-action-get-name))

(defun gtk-action-get-name (action)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{the action object}
  @return{The name of the action.}
  @short{Returns the name of the action.}
  Since 2.4"
  (gtk-action-name action))

(export 'gtk-action-get-name)

;;; ----------------------------------------------------------------------------
;;; gtk_action_is_sensitive ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_is_sensitive" gtk-action-is-sensitive) :boolean
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{the action object}
  @return{@arg{true} if the action and its associated action group are both
    sensitive.}
  @short{Returns whether the action is effectively sensitive.}
  Since 2.4."
  (action g-object))

(export 'gtk-action-is-sensitive)

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_sensitive ()
;;;
;;; gboolean gtk_action_get_sensitive (GtkAction *action);
;;;
;;; Returns whether the action itself is sensitive. Note that this doesn't
;;; necessarily mean effective sensitivity. See gtk_action_is_sensitive() for
;;; that.
;;;
;;; action :
;;;     the action object
;;;
;;; Returns :
;;;     TRUE if the action itself is sensitive.
;;;
;;; Since 2.4
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_sensitive ()
;;;
;;; void gtk_action_set_sensitive (GtkAction *action, gboolean sensitive);
;;;
;;; Sets the ::sensitive property of the action to sensitive. Note that this
;;; doesn't necessarily mean effective sensitivity. See
;;; gtk_action_is_sensitive() for that.
;;;
;;; action :
;;;     the action object
;;;
;;; sensitive :
;;;     TRUE to make the action sensitive
;;;
;;; Since 2.6
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_is_visible ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_is_visible" gtk-action-is-visible) :boolean
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{the action object}
  @return{@arg{true} if the action and its associated action group are both
    visible.}
  @short{Returns whether the action is effectively visible.}
  Since 2.4"
  (action g-object))

(export 'gtk-action-is-visible)

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_visible ()
;;;
;;; gboolean gtk_action_get_visible (GtkAction *action);
;;;
;;; Returns whether the action itself is visible. Note that this doesn't
;;; necessarily mean effective visibility. See gtk_action_is_sensitive() for
;;; that.
;;;
;;; action :
;;;     the action object
;;;
;;; Returns :
;;;     TRUE if the action itself is visible.
;;;
;;; Since 2.4
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_visible ()
;;;
;;; void gtk_action_set_visible (GtkAction *action, gboolean visible);
;;;
;;; Sets the ::visible property of the action to visible. Note that this doesn't
;;; necessarily mean effective visibility. See gtk_action_is_visible() for that.
;;;
;;; action :
;;;     the action object
;;;
;;; visible :
;;;     TRUE to make the action visible
;;;
;;; Since 2.6
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_activate ()
;;;
;;; void gtk_action_activate (GtkAction *action);
;;;
;;; Emits the "activate" signal on the specified action, if it isn't
;;; insensitive. This gets called by the proxy widgets when they get activated.
;;;
;;; It can also be used to manually activate an action.
;;;
;;; action :
;;;     the action object
;;;
;;; Since 2.4
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_create_icon ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_create_icon" gtk-action-create-icon) g-object
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{the action object}
  @argument[icon-size]{the size of the icon that should be created}
  @return{A widget that displays the icon for this action.}
  @begin{short}
    This function is intended for use by action implementations to create icons
    displayed in the proxy widgets.
  @end{short}
  Since 2.4"
  (action g-object)
  (icon-size gtk-icon-size))

(export 'gtk-action-create-icon)

;;; ----------------------------------------------------------------------------
;;; gtk_action_create_menu_item ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_create_menu_item" gtk-action-create-menu-item) g-object
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{the action object}
  @return{A menu item connected to the action.}
  @short{Creates a menu item widget that proxies for the given action.}
  Since 2.4"
  (action g-object))

(export 'gtk-action-create-menu-item)

;;; ----------------------------------------------------------------------------
;;; gtk_action_create_tool_item ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_create_tool_item" gtk-action-create-tool-item) g-object
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{the action object}
  @return{A toolbar item connected to the action.}
  @short{Creates a toolbar item widget that proxies for the given action.}
  Since 2.4"
  (action g-object))

(export 'gtk-action-create-tool-item)

;;; ----------------------------------------------------------------------------
;;; gtk_action_create_menu ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_create_menu" gtk-action-create-menu) g-object
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{a @class{gtk-action} object.}
  @return{The menu item provided by the action, or @code{nil}.}
  @begin{short}
    If action provides a @class{gtk-menu} widget as a submenu for the menu item
    or the toolbar item it creates, this function returns an instance of that
    menu.
  @end{short}@break{}
  Since 2.12"
  (action g-object))

(export 'gtk-action-create-menu)

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_proxies ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_get_proxies" gtk-action-proxies)
    (g-slist g-object :free-from-foreign nil)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{the action object}
  @return{A @type{g-slist} of proxy widgets.}
  @short{Returns the proxy widgets for an action.}
  See also @fun{gtk-activatable-get-related-action}.
 Since 2.4"
  (action g-object))

(export 'gtk-action-proxies)

;;; ----------------------------------------------------------------------------
;;; gtk_action_connect_accelerator ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_connect_accelerator" gtk-action-connect-accelerator) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{a @class{gtk-action} object}
  @begin{short}
    Installs the accelerator for action if action has an accel path and group.
  @end{short}
  See @fun{gtk-action-set-accel-path} and @fun{gtk-action-set-accel-group}.

  Since multiple proxies may independently trigger the installation of the
  accelerator, the action counts the number of times this function has been
  called and doesn't remove the accelerator until
  @fun{gtk-action-disconnect-accelerator} has been called as many times.

 Since 2.4"
  (action g-object))

(export 'gtk-action-connect-accelerator)

;;; ----------------------------------------------------------------------------
;;; gtk_action_disconnect_accelerator ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_disconnect_accelerator" gtk-action-disconnect-accelerator)
    :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{a @class{gtk-action} object}
  @begin{short}
    Undoes the effect of one call to @fun{gtk-action-connect-ccelerator}.
  @end{short}
  Since 2.4"
  (action g-object))

(export 'gtk-action-disconnect-accelerator)

;;; ----------------------------------------------------------------------------
;;; gtk_action_block_activate ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_block_activate" gtk-action-block-activate) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{a @class{gtk-action} object}
  @short{Disable activation signals from the action}

  This is needed when updating the state of your proxy GtkActivatable widget
  could result in calling gtk_action_activate(), this is a convenience
  function to avoid recursing in those cases (updating toggle state for
  instance).

  Since 2.16"
  (action (g-object gtk-action)))

(export 'gtk-action-block-activate)

;;; ----------------------------------------------------------------------------
;;; gtk_action_unblock_activate ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_unblock_activate" gtk-action-unblock-activate) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{a @class{gtk-action} object}
  @short{Reenable activation signals from the action.}
  Since 2.16"
  (action (g-object gtk-action)))

(export 'gtk-action-unblock-activate)

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_always_show_image ()
;;;
;;; gboolean gtk_action_get_always_show_image (GtkAction *action);
;;;
;;; Returns whether action's menu item proxies will ignore the "gtk-menu-images"
;;; setting and always show their image, if available.
;;;
;;; action :
;;;     a GtkAction
;;;
;;; Returns :
;;;     TRUE if the menu item proxies will always show their image
;;;
;;; Since 2.20
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_always_show_image ()
;;;
;;; void gtk_action_set_always_show_image (GtkAction *action,
;;;                                        gboolean always_show);
;;;
;;; Sets whether action's menu item proxies will ignore the "gtk-menu-images"
;;; setting and always show their image, if available.
;;;
;;; Use this if the menu item would be useless or hard to use without their
;;; image.
;;;
;;; action :
;;;     a GtkAction
;;;
;;; always_show :
;;;     TRUE if menuitem proxies should always show their image
;;;
;;; Since 2.20
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_accel_path ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_get_accel_path" gtk-action-get-accel-path) :string
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{the action object}
  @return{the accel path for this action, or @code{nil} if none is set.}
  @short{Returns the accel path for this action.}
  Since 2.6"
  (action (g-object gtk-action)))

(export 'gtk-action-get-accel-path)

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_accel_path ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_set_accel_path" gtk-action-set-accel-path) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{the action object}
  @argument[accel-path]{the accelerator path}
  @begin{short}
    Sets the accel path for this action. All proxy widgets associated with the
    action will have this accel path, so that their accelerators are consistent.
  @end{short}

  Note that @arg{accel-path} string will be stored in a @type{g-quark}.
  Therefore, if you pass a static string, you can save some memory by interning
  it first with @fun{g-intern-static-string}.

  Since 2.4"
  (action (g-object gtk-action))
  (accel-path :string))

(export 'gtk-action-set-accel-path)

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_accel_closure ()
;;;
;;; GClosure * gtk_action_get_accel_closure (GtkAction *action);
;;;
;;; Returns the accel closure for this action.
;;;
;;; action :
;;;     the action object
;;;
;;; Returns :
;;;     the accel closure for this action. The returned closure is owned by GTK+
;;;     and must not be unreffed or modified.
;;;
;;; Since 2.8
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_accel_group ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_action_set_accel_group" gtk-action-set-accel-group) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-9}
  @argument[action]{the action object}
  @argument[accel-group]{a @class{gtk-accel-group} or @code{nil}}
  @begin{short}
    Sets the @class{gtk-accel-group} in which the accelerator for this action
    will be installed.
  @end{short}

  Since 2.4"
  (action (g-object gtk-action))
  (accel-group (g-object gtk-accel-group)))

(export 'gtk-action-set-accel-group)

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_label ()
;;;
;;; void gtk_action_set_label (GtkAction *action, const gchar *label);
;;;
;;; Sets the label of action.
;;;
;;; action :
;;;     a GtkAction
;;;
;;; label :
;;;     the label text to set
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_label ()
;;;
;;; const gchar * gtk_action_get_label (GtkAction *action);
;;;
;;; Gets the label text of action.
;;;
;;; action :
;;;     a GtkAction
;;;
;;; Returns :
;;;     the label text
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_short_label ()
;;;
;;; void gtk_action_set_short_label (GtkAction *action,
;;;                                  const gchar *short_label);
;;;
;;; Sets a shorter label text on action.
;;;
;;; action :
;;;     a GtkAction
;;;
;;; short_label :
;;;     the label text to set
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_short_label ()
;;;
;;; const gchar * gtk_action_get_short_label (GtkAction *action);
;;;
;;; Gets the short label text of action.
;;;
;;; action :
;;;     a GtkAction
;;;
;;; Returns :
;;;     the short label text.
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_tooltip ()
;;;
;;; void gtk_action_set_tooltip (GtkAction *action, const gchar *tooltip);
;;;
;;; Sets the tooltip text on action
;;;
;;; action :
;;;     a GtkAction
;;;
;;; tooltip :
;;;     the tooltip text
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_tooltip ()
;;;
;;; const gchar * gtk_action_get_tooltip (GtkAction *action);
;;;
;;; Gets the tooltip text of action.
;;;
;;; action :
;;;     a GtkAction
;;;
;;; Returns :
;;;     the tooltip text
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_stock_id ()
;;;
;;; void gtk_action_set_stock_id (GtkAction *action, const gchar *stock_id);
;;;
;;; Sets the stock id on action
;;;
;;; action :
;;;     a GtkAction
;;;
;;; stock_id :
;;;     the stock id
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_stock_id ()
;;;
;;; const gchar * gtk_action_get_stock_id (GtkAction *action);
;;;
;;; Gets the stock id of action.
;;;
;;; action :
;;;     a GtkAction
;;;
;;; Returns :
;;;     the stock id
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_gicon ()
;;;
;;; void gtk_action_set_gicon (GtkAction *action, GIcon *icon);
;;;
;;; Sets the icon of action.
;;;
;;; action :
;;;     a GtkAction
;;;
;;; icon :
;;;     the GIcon to set
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_gicon ()
;;;
;;; GIcon * gtk_action_get_gicon (GtkAction *action);
;;;
;;; Gets the gicon of action.
;;;
;;; action :
;;;     a GtkAction
;;;
;;; Returns :
;;;     The action's GIcon if one is set.
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_icon_name ()
;;;
;;; void gtk_action_set_icon_name (GtkAction *action, const gchar *icon_name);
;;;
;;; Sets the icon name on action
;;;
;;; action :
;;;     a GtkAction
;;;
;;; icon_name :
;;;     the icon name to set
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_icon_name ()
;;;
;;; const gchar * gtk_action_get_icon_name (GtkAction *action);
;;;
;;; Gets the icon name of action.
;;;
;;; action :
;;;     a GtkAction
;;;
;;; Returns :
;;;     the icon name
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_visible_horizontal ()
;;;
;;; void gtk_action_set_visible_horizontal (GtkAction *action,
;;;                                         gboolean visible_horizontal);
;;;
;;; Sets whether action is visible when horizontal
;;;
;;; action :
;;;     a GtkAction
;;;
;;; visible_horizontal :
;;;     whether the action is visible horizontally
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_visible_horizontal ()
;;;
;;; gboolean gtk_action_get_visible_horizontal (GtkAction *action);
;;;
;;; Checks whether action is visible when horizontal
;;;
;;; action :
;;;     a GtkAction
;;;
;;; Returns :
;;;     whether action is visible when horizontal
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_visible_vertical ()
;;;
;;; void gtk_action_set_visible_vertical (GtkAction *action,
;;;                                       gboolean visible_vertical);
;;;
;;; Sets whether action is visible when vertical
;;;
;;; action :
;;;     a GtkAction
;;;
;;; visible_vertical :
;;;     whether the action is visible vertically
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_visible_vertical ()
;;;
;;; gboolean gtk_action_get_visible_vertical (GtkAction *action);
;;;
;;; Checks whether action is visible when horizontal
;;;
;;; action :
;;;     a GtkAction
;;;
;;; Returns :
;;;     whether action is visible when horizontal
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_set_is_important ()
;;;
;;; void gtk_action_set_is_important (GtkAction *action, gboolean is_important);
;;;
;;; Sets whether the action is important, this attribute is used primarily by
;;; toolbar items to decide whether to show a label or not.
;;;
;;; action :
;;;     the action object
;;;
;;; is_important :
;;;     TRUE to make the action important
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------

;;; ----------------------------------------------------------------------------
;;; gtk_action_get_is_important ()
;;;
;;; gboolean gtk_action_get_is_important (GtkAction *action);
;;;
;;; Checks whether action is important or not
;;;
;;; action :
;;;     a GtkAction
;;;
;;; Returns :
;;;     whether action is important
;;;
;;; Since 2.16
;;; ----------------------------------------------------------------------------


;;; --- End of file gtk.action.lisp --------------------------------------------
