;;; ----------------------------------------------------------------------------
;;; gtk.info-bar.lisp
;;;
;;; The documentation has been copied from the GTK+ 3 Reference Manual
;;; Version 3.4.3. See http://www.gtk.org.
;;;
;;; Copyright (C) 2012 - 2013 Dieter Kaiser
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
;;;
;;; ----------------------------------------------------------------------------
;;;
;;; GtkInfoBar
;;; 
;;; Report important messages to the user
;;;     
;;; Synopsis
;;; 
;;;     GtkInfoBar
;;;     
;;;     gtk_info_bar_new
;;;     gtk_info_bar_new_with_buttons
;;;     gtk_info_bar_add_action_widget
;;;     gtk_info_bar_add_button
;;;     gtk_info_bar_add_buttons
;;;     gtk_info_bar_set_response_sensitive
;;;     gtk_info_bar_set_default_response
;;;     gtk_info_bar_response
;;;     gtk_info_bar_set_message_type
;;;     gtk_info_bar_get_message_type
;;;     gtk_info_bar_get_action_area
;;;     gtk_info_bar_get_content_area
;;; 
;;; Object Hierarchy
;;; 
;;;   GObject
;;;    +----GInitiallyUnowned
;;;          +----GtkWidget
;;;                +----GtkContainer
;;;                      +----GtkBox
;;;                            +----GtkInfoBar
;;; 
;;; Implemented Interfaces
;;; 
;;; GtkInfoBar implements AtkImplementorIface, GtkBuildable and GtkOrientable.
;;; 
;;; Properties
;;; 
;;;   "message-type"             GtkMessageType       : Read / Write / Construct
;;; 
;;; Style Properties
;;; 
;;;   "action-area-border"       gint                 : Read
;;;   "button-spacing"           gint                 : Read
;;;   "content-area-border"      gint                 : Read
;;;   "content-area-spacing"     gint                 : Read
;;; 
;;; Signals
;;; 
;;;   "close"                                         : Action
;;;   "response"                                      : Run Last
;;; 
;;; Description
;;; 
;;; GtkInfoBar is a widget that can be used to show messages to the user without
;;; showing a dialog. It is often temporarily shown at the top or bottom of a
;;; document. In contrast to GtkDialog, which has a horizontal action area at
;;; the bottom, GtkInfoBar has a vertical action area at the side.
;;; 
;;; The API of GtkInfoBar is very similar to GtkDialog, allowing you to add
;;; buttons to the action area with gtk_info_bar_add_button() or
;;; gtk_info_bar_new_with_buttons(). The sensitivity of action widgets can be
;;; controlled with gtk_info_bar_set_response_sensitive(). To add widgets to the
;;; main content area of a GtkInfoBar, use gtk_info_bar_get_content_area() and
;;; add your widgets to the container.
;;; 
;;; Similar to GtkMessageDialog, the contents of a GtkInfoBar can by classified
;;; as error message, warning, informational message, etc, by using
;;; gtk_info_bar_set_message_type(). GTK+ uses the message type to determine the
;;; background color of the message area.
;;; 
;;; Example 52. Simple GtkInfoBar usage.
;;; 
;;; /* set up info bar */
;;; info_bar = gtk_info_bar_new ();
;;; gtk_widget_set_no_show_all (info_bar, TRUE);
;;; message_label = gtk_label_new ("");
;;; gtk_widget_show (message_label);
;;; content_area = gtk_info_bar_get_content_area (GTK_INFO_BAR (info_bar));
;;; gtk_container_add (GTK_CONTAINER (content_area), message_label);
;;; gtk_info_bar_add_button (GTK_INFO_BAR (info_bar),
;;;                          GTK_STOCK_OK, GTK_RESPONSE_OK);
;;; g_signal_connect (info_bar, "response",
;;;                   G_CALLBACK (gtk_widget_hide), NULL);
;;; gtk_grid_attach (GTK_GRID (grid),
;;;                  info_bar,
;;;                  0, 2, 1, 1);
;;; 
;;; /* ... */
;;; 
;;; /* show an error message */
;;; gtk_label_set_text (GTK_LABEL (message_label), error_message);
;;; gtk_info_bar_set_message_type (GTK_INFO_BAR (info_bar),
;;;                                GTK_MESSAGE_ERROR);
;;; gtk_widget_show (info_bar);
;;; 
;;; 
;;; GtkInfoBar as GtkBuildable
;;; 
;;; The GtkInfoBar implementation of the GtkBuildable interface exposes the
;;; content area and action area as internal children with the names
;;; "content_area" and "action_area".
;;; 
;;; GtkInfoBar supports a custom <action-widgets> element, which can contain
;;; multiple <action-widget> elements. The "response" attribute specifies a
;;; numeric response, and the content of the element is the id of widget (which
;;; should be a child of the dialogs action_area).
;;; 
;;; ----------------------------------------------------------------------------
;;;
;;; Property Details
;;;
;;; ----------------------------------------------------------------------------
;;; The "message-type" property
;;; 
;;;   "message-type"             GtkMessageType       : Read / Write / Construct
;;; 
;;; The type of the message.
;;; 
;;; The type is used to determine the colors to use in the info bar. The
;;; following symbolic color names can by used to customize these colors:
;;; "info_fg_color", "info_bg_color", "warning_fg_color", "warning_bg_color",
;;; "question_fg_color", "question_bg_color", "error_fg_color",
;;; "error_bg_color". "other_fg_color", "other_bg_color".
;;; 
;;; If the type is GTK_MESSAGE_OTHER, no info bar is painted but the colors are
;;; still set.
;;; 
;;; Default value: GTK_MESSAGE_INFO
;;; 
;;; Since 2.18
;;;
;;; ----------------------------------------------------------------------------
;;;
;;; Style Property Details
;;;
;;; ----------------------------------------------------------------------------
;;; The "action-area-border" style property
;;; 
;;;   "action-area-border"       gint                  : Read
;;; 
;;; Width of the border around the action area of the info bar.
;;; 
;;; Allowed values: >= 0
;;; 
;;; Default value: 5
;;; 
;;; Since 2.18
;;;
;;; ----------------------------------------------------------------------------
;;; The "button-spacing" style property
;;; 
;;;   "button-spacing"           gint                  : Read
;;; 
;;; Spacing between buttons in the action area of the info bar.
;;; 
;;; Allowed values: >= 0
;;; 
;;; Default value: 6
;;; 
;;; Since 2.18
;;;
;;; ----------------------------------------------------------------------------
;;; The "content-area-border" style property
;;; 
;;;   "content-area-border"      gint                  : Read
;;; 
;;; The width of the border around the content content area of the info bar.
;;; 
;;; Allowed values: >= 0
;;; 
;;; Default value: 8
;;; 
;;; Since 2.18
;;;
;;; ----------------------------------------------------------------------------
;;; The "content-area-spacing" style property
;;; 
;;;   "content-area-spacing"     gint                  : Read
;;; 
;;; The default spacing used between elements of the content area of the info
;;; bar.
;;; 
;;; Allowed values: >= 0
;;; 
;;; Default value: 16
;;; 
;;; Since 2.18
;;;
;;; ----------------------------------------------------------------------------
;;;
;;; Signal Details
;;;
;;; ----------------------------------------------------------------------------
;;; The "close" signal
;;; 
;;; void user_function (GtkInfoBar *arg0,
;;;                     gpointer    user_data)      : Action
;;; 
;;; The ::close signal is a keybinding signal which gets emitted when the user
;;; uses a keybinding to dismiss the info bar.
;;; 
;;; The default binding for this signal is the Escape key.
;;; 
;;; user_data :
;;;     user data set when the signal handler was connected.
;;; 
;;; Since 2.18
;;;
;;; ----------------------------------------------------------------------------
;;; The "response" signal
;;; 
;;; void user_function (GtkInfoBar *info_bar,
;;;                     gint        response_id,
;;;                     gpointer    user_data)        : Run Last
;;; 
;;; Emitted when an action widget is clicked or the application programmer calls
;;; gtk_dialog_response(). The response_id depends on which action widget was
;;; clicked.
;;; 
;;; info_bar :
;;;     the object on which the signal is emitted
;;; 
;;; response_id :
;;;     the response ID
;;; 
;;; user_data :
;;;     user data set when the signal handler was connected.
;;; 
;;; Since 2.18
;;; ----------------------------------------------------------------------------

(in-package :gtk)

;;; ----------------------------------------------------------------------------
;;; struct GtkInfoBar
;;; 
;;; struct GtkInfoBar;
;;; ----------------------------------------------------------------------------

(define-g-object-class "GtkInfoBar" gtk-info-bar
  (:superclass gtk-box
   :export t
   :interfaces ("AtkImplementorIface"
                "GtkBuildable"
                "GtkOrientable")
   :type-initializer "gtk_info_bar_get_type")
  ((message-type
    gtk-message-type
    "message-type" "GtkMessageType" t t)))

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-new
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-info-bar-new))

(defun gtk-info-bar-new ()
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @return{A new @class{gtk-info-bar} widget.}
  @begin{short}
    Creates a new @class{gtk-info-bar} widget.
  @end{short}@break{}
  Since 2.18"
  (make-instance 'gtk-info-bar))

(export 'gtk-info-bar-new)

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-new-with-buttons
;;; ----------------------------------------------------------------------------

(defun gtk-info-bar-new-with-buttons (&rest args)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @argument[args]{first the stock ID or text and second the response ID for
    each button, then more pairs for each button}
  @return{A new @class{gtk-info-bar} widget.}
  @begin{short}
    Creates a new @class{gtk-info-bar} with buttons.
  @end{short}
  Button text/response ID pairs should be listed. Button text can be either a
  stock ID such as @code{GTK_STOCK_OK}, or some arbitrary text. A response ID
  can be any positive number, or one of the values in the 
  @symbol{gtk-response-type} enumeration. If the user clicks one of these dialog
  buttons, @class{gtk-info-bar} will emit the \"response\" signal with the
  corresponding response ID."
  (let ((info-bar (make-instance 'gtk-info-bar-new)))
    (gtk-info-bar-add-buttons info-bar args)))

(export 'gtk-info-bar-new-with-buttons)

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-add-action-widget
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_info_bar_add_action_widget" gtk-info-bar-add-action-widget) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @argument[info-bar]{a @class{gtk-info-bar} widget}
  @argument[child]{an activatable widget}
  @argument[response-id]{response ID for @arg{child}}
  @begin{short}
    Add an activatable widget to the action area of a @class{gtk-info-bar},
    connecting a signal handler that will emit the \"response\" signal on the
    message area when the widget is activated.
  @end{short}
  The widget is appended to the end of the message areas action area.@break{}
  Since 2.18"
  (info-bar (g-object gtk-info-bar))
  (child (g-object gtk-widget))
  (response-id :int))

(export 'gtk-info-bar-add-action-widget)

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-add-button
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_info_bar_add_button" gtk-info-bar-add-button)
    (g-object gtk-widget)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @argument[info-bar]{a @class{gtk-info-bar} widget}
  @argument[button-text]{text of button, or stock ID}
  @argument[response-id]{response ID for the button}
  @return{The @class{gtk-button} widget that was added.}
  @begin{short}
    Adds a button with the given text (or a stock button, if @arg{button-text}
    is a stock ID) and sets things up so that clicking the button will emit the
    \"response\" signal with the given @arg{response-id}.
  @end{short}
  The button is appended to the end of the info bars's action area. The button
  widget is returned, but usually you don't need it.@break{}
  Since 2.18"
  (info-bar (g-object gtk-info-bar))
  (button-text :string)
  (response-id :int))

(export 'gtk-info-bar-add-button)

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-add-buttons
;;; ----------------------------------------------------------------------------

(defun gtk-info-bar-add-buttons (info-bar &rest args)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @argument[info-bar]{a @class{gtk-info-bar} widget}
  @argument[args]{first a button text or stock ID and second a response ID,
    then more pairs for each button}
  @begin{short}
    Adds more buttons, same as calling @fun{gtk-info-bar-add-button} repeatedly.
  @end{short}
  Each button must have both text and response ID.@break{}
  Since 2.18"
  (let ((n (/ (length args) 2)))
    (assert (eql n (truncate (length args) 2)))
    (dotimes (i n)
      (gtk-info-bar-add-button info-bar (pop args) (pop args)))))

(export 'gtk-info-bar-add-buttons)

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-set-response-sensitive
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_info_bar_set_response_sensitive"
           gtk-info-bar-set-response-sensitive) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @argument[info-bar]{a @class{gtk-info-bar} widget}
  @argument[response-id]{a response ID}
  @argument[setting]{@arg{true} for sensitive}
  @begin{short}
    Calls @code{(@fun{gtk-widget-set-sensitive} widget @arg{setting})} for each
    widget in the info bars's action area with the given @arg{response-id}.
  @end{short}
  A convenient way to sensitize/desensitize dialog buttons.@break{}
  Since 2.18"
  (info-bar (g-object gtk-info-bar))
  (response-id :int)
  (setting :boolean))

(export 'gtk-info-bar-set-response-sensitive)

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-set-default-response
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_info_bar_set_default_response" gtk-info-bar-set-default-response)
    :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @argument[info-bar]{a @class{gtk-info-bar} widget}
  @argument[response-id]{a response ID}
  @begin{short}
    Sets the last widget in the info bar's action area with the given
    @arg{response-id} as the default widget for the dialog. Pressing \"Enter\"
    normally activates the default widget.
  @end{short}@break{}
  Note that this function currently requires @arg{info-bar} to be added to a
  widget hierarchy.@break{}
  Since 2.18"
  (info-bar (g-object gtk-info-bar))
  (response-id :int))

(export 'gtk-info-bar-set-default-response)

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-response
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_info_bar_response" gtk-info-bar-response) :void
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @argument[info-bar]{a @class{gtk-info-bar} widget}
  @argument[response-id]{a response ID}
  @begin{short}
    Emits the \"response\" signal with the given @arg{response-id}.
  @end{short}@break{}
  Since 2.18"
  (info-bar (g-object gtk-info-bar))
  (response-id :int))

(export 'gtk-info-bar-response)

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-set-message-type
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-info-bar-set-message-type))

(defun gtk-info-bar-set-message-type (info-bar message-type)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @argument[info-bar]{a @class{gtk-info-bar} widget}
  @argument[message-type]{a @symbol{gtk-message-type}}
  @begin{short}
    Sets the message type of the message area. GTK+ uses this type to determine
    what color to use when drawing the message area.
  @end{short}@break{}
  Since 2.18"
  (setf (gtk-info-bar-message-type info-bar) message-type))

(export 'gtk-info-bar-set-message-type)

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-get-message-type
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-info-bar-get-message-type))

(defun gtk-info-bar-get-message-type (info-bar)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @argument[info-bar]{a @class{gtk-info-bar} widget}
  @return{The message type of the message area.}
  @begin{short}
    Returns the message type of the message area.
  @end{short}@break{}
  Since 2.18"
  (gtk-info-bar-message-type info-bar))

(export 'gtk-info-bar-get-message-type)

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-get-action-area
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_info_bar_get_action_area" gtk-info-bar-get-action-area)
    (g-object gtk-widget)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @argument[info-bar]{a @class{gtk-info-bar} widget}
  @return{The action area.}
  @begin{short}
    Returns the action area of @arg{info-bar}.
  @end{short}@break{}
  Since 2.18"
  (info-bar (g-object gtk-info-bar)))

(export 'gtk-info-bar-get-action-area)

;;; ----------------------------------------------------------------------------
;;; gtk-info-bar-get-content-area
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_info_bar_get_content_area" gtk-info-bar-get-content-area)
    (g-object gtk-widget)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-3}
  @argument[info-bar]{a @class{gtk-info-bar} widget}
  @return{The content area.}
  @begin{short}
    Returns the content area of @arg{info-bar}.
  @end{short}@break{}
  Since 2.18"
  (info-bar (g-object gtk-info-bar)))

(export 'gtk-info-bar-get-content-area)

;;; --- End of file gtk.info-bar.lisp ------------------------------------------
