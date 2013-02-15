;;; ----------------------------------------------------------------------------
;;; gtk.application-window.lisp
;;;
;;; The documentation has been copied from the GTK+ 3 Reference Manual
;;; Version 3.4.3. See http://www.gtk.org.
;;;
;;; Copyright (C) 2013 Dieter Kaiser
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
;;; GtkApplicationWindow
;;;
;;; GtkWindow subclass with GtkApplication support
;;;
;;; Synopsis
;;;
;;;     GtkApplicationWindow
;;;
;;;     gtk_application_window_new
;;;     gtk_application_window_set_show_menubar
;;;     gtk_application_window_get_show_menubar
;;; ----------------------------------------------------------------------------

(in-package :gtk)

;;; ----------------------------------------------------------------------------
;;; struct GtkApplicationWindow
;;;
;;; struct GtkApplicationWindow;
;;; ----------------------------------------------------------------------------

(define-g-object-class "GtkApplicationWindow" gtk-application-window
  (:superclass gtk-window
   :export t
   :interfaces ("AtkImplementorIface"
                "GtkBuildable"
                "GActionGroup"
                "GActionMap")
   :type-initializer "gtk_application_window_get_type")
   ((show-menubar
     gtk-application-window-show-menubar
     "show-menubar" "gboolean" t t)))

;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation 'gtk-application-window 'type)
 "@version{2013-2-12}
  @begin{short}
    GtkApplicationWindow is a GtkWindow subclass that offers some extra
    functionality for better integration with GtkApplication features. Notably,
    it can handle both the application menu as well as the menubar. See
    gtk_application_set_app_menu() and gtk_application_set_menubar().
  @end{short}

 This class implements the GActionGroup and GActionMap interfaces, to let you
 add window-specific actions that will be exported by the associated
 GtkApplication, together with its application-wide actions. Window-specific
 actions are prefixed with the \"win\". prefix and application-wide actions are
 prefixed with the \"app\". prefix. Actions must be addressed with the prefixed
 name when referring to them from a GMenuModel.

  Note that widgets that are placed inside a GtkApplicationWindow can also
  activate these actions, if they implement the GtkActionable interface.

  As with GtkApplication, the GDK lock will be acquired when processing
  actions arriving from other processes and should therefore be held when
  activating actions locally (if GDK threads are enabled).

  The settings \"gtk-shell-shows-app-menu\" and \"gtk-shell-shows-menubar\" tell
  GTK+ whether the desktop environment is showing the application menu and
  menubar models outside the application as part of the desktop shell. For
  instance, on OS X, both menus will be displayed remotely; on Windows neither
  will be. gnome-shell (starting with version 3.4) will display the
  application menu, but not the menubar.

  If the desktop environment does not display the menubar, then
  GApplicationWindow will automatically show a GtkMenubar for it. (see the
  GtkApplication docs for some screenshots of how this looks on different
  platforms). This behaviour can be overridden with the \"show-menubar\"
  property. If the desktop environment does not display the application menu,
  then it will automatically be included in the menubar.
 
  Example 111. A GtkApplicationWindow with a menubar
  @begin{pre}
 app = gtk_application_new ();

 builder = gtk_builder_new ();
 gtk_builder_add_from_string (builder,
    \"<interface>\"
    \"  <menu id='menubar'>\"
    \"    <submenu label='_Edit'>\"
    \"      <item label='_Copy' action='win.copy'/>\"
    \"      <item label='_Paste' action='win.paste'/>\"
    \"    </submenu>\"
    \"  </menu>\"
    \"</interface>\");
  gtk_application_set_menubar
                (G_APPLICATION (app),
                 G_MENU_MODEL (gtk_builder_get_object (builder, \"menubar\")));
 g_object_unref (builder);

 ...

 window = gtk_application_window_new (app);
  @end{pre}
  The XML format understood by GtkBuilder for GMenuModel consists of a
  toplevel <menu> element, which contains one or more <item> elements. Each
  <item> element contains <attribute> and <link> elements with a mandatory
  name attribute. <link> elements have the same content model as <menu>.

  Attribute values can be translated using gettext, like other GtkBuilder
  content. <attribute> elements can be marked for translation with a
  translatable=\"yes\" attribute. It is also possible to specify message context
  and translator comments, using the context and comments attributes. To make
  use of this, the GtkBuilder must have been given the gettext domain to use.
  @see-slot{gtk-application-window-show-menubar}
")

;;; ----------------------------------------------------------------------------
;;;
;;; Property Details
;;;
;;; ----------------------------------------------------------------------------

#+cl-cffi-gtk-documentation
(setf (documentation (atdoc:get-slot-from-name "show-menubar" 'gtk-application-window) 't)
 "The @code{\"show-menubar\"} property of type @code{gboolean}
  (Read / Write / Construct)@br{}
  If this property is TRUE, the window will display a menubar that includes
  the app menu and menubar, unless these are shown by the desktop shell. See
  gtk_application_set_app_menu() and gtk_application_set_menubar().@br{}
  If FALSE, the window will not display a menubar, regardless of whether the
  desktop shell is showing the menus or not.@br{}
  Default value: @code{true}")

;;; ----------------------------------------------------------------------------
;;;
;;; Accessors
;;;
;;; ----------------------------------------------------------------------------

;;; --- gtk-application-window-show-menubar ------------------------------------

#+cl-cffi-gtk-documentation
(setf (gethash 'gtk-application-window-show-menubar atdoc:*function-name-alias*)
      "Accessor"
      (documentation 'gtk-application-window-show-menubar 'function)
 "@version{2013-2-12}
  @begin{short}
    Accessor of the slot @code{\"show-menubar\"} of the
    @class{gtk-application-window} class.
  @end{short}")

;;; ----------------------------------------------------------------------------
;;; gtk_application_window_new ()
;;; ----------------------------------------------------------------------------

(defcfun ("gtk_application_window_new" gtk-application-window-new)
    (g-object gtk-widget)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-12}
  @argument[application]{a GtkApplication}
  @return{a newly created GtkApplicationWindow}
  @short{Creates a new GtkApplicationWindow.}

  Since 3.4"
  (application (g-object gtk-application)))

(export 'gtk-application-window-new)

;;; ----------------------------------------------------------------------------
;;; gtk_application_window_set_show_menubar ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-application-window-set-show-menubar))

(defun gtk-application-window-set-show-menubar (window show-menubar)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-12}
  @argument[window]{a GtkApplicationWindow}
  @argument[show_menubar]{whether to show a menubar when needed}
  @begin{short}
    Sets whether the window will display a menubar for the app menu and menubar
    as needed.
  @end{short}

  Since 3.4"
  (setf (gtk-application-window-show-menubar window) show-menubar))

(export 'gtk-application-window-set-show-menubar)

;;; ----------------------------------------------------------------------------
;;; gtk_application_window_get_show_menubar ()
;;; ----------------------------------------------------------------------------

(declaim (inline gtk-application-window-get-show-menubar))

(defun gtk-application-window-get-show-menubar (window)
 #+cl-cffi-gtk-documentation
 "@version{2013-2-12}
  @argument[window]{a GtkApplicationWindow}
  @return{TRUE if window will display a menubar when needed}
  @begin{short}
    Returns whether the window will display a menubar for the app menu and
    menubar as needed.
  @end{short}

  Since 3.4"
  (gtk-application-window-show-menubar window))

(export 'gtk-application-window-get-show-menubar)

;;; --- End of file gtk.application-window.lisp --------------------------------
