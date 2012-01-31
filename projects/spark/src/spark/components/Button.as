////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2008 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package spark.components
{

import flash.events.Event;
import spark.components.supportClasses.ButtonBase;
import mx.core.IButton;
 
//--------------------------------------
//  Other metadata
//--------------------------------------

[IconFile("Button.png")]

/**
 *  The Button component is a commonly used rectangular button.
 *  The Button component looks like it can be pressed.
 *  It can have a text label, an icon, or both on its face.
 *
 *  <p>Buttons typically use event listeners to perform an action 
 *  when the user selects the control. When a user clicks the mouse 
 *  on a Button control, and the Button control is enabled, 
 *  it dispatches a <code>click</code> event and a <code>buttonDown</code> event. 
 *  A button always dispatches events such as the <code>mouseMove</code>, 
 *  <code>mouseOver</code>, <code>mouseOut</code>, <code>rollOver</code>, 
 *  <code>rollOut</code>, <code>mouseDown</code>, and 
 *  <code>mouseUp</code> events whether enabled or disabled.</p>
 *
 *  @mxml <p>The <code>&lt;Button&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;Button
 
 *    <strong>Properties</strong>
 *    emphasized="false"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/ButtonExample.mxml
 *  @see spark.skins.default.ButtonSkin
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class Button extends ButtonBase implements IButton
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */    
    public function Button()
    {
        super();
    }   

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  emphasized
    //----------------------------------

    /**
     *  @private
     *  Storage for the emphasized property.
     */
    private var _emphasized:Boolean = false;

    [Bindable("emphasizedChanged")]
    [Inspectable(category="General", defaultValue="false")]

    /**
     * Reflects the default button as requested by the
     * focus manager. This property is typically set 
     * by the focus manager when a button serves as the 
     * default button in a container or form. 
     * When set to true, the <code>emphasized</code> style
     * is appended to the button's <code>styleName</code> 
     * property.
     *
     *  @default false
     *  @see mx.managers.FocusManager.defaultButton
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get emphasized():Boolean 
    { 
        return _emphasized;
    }
    
    /**
     *  @private
     */
    public function set emphasized(value:Boolean):void 
    {
        if (value == _emphasized)
            return;
            
        _emphasized = value;
        emphasizeStyleName();  
        dispatchEvent(new Event("emphasizedChanged"));
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    override public function set styleName(value:Object):void
    {
        super.styleName = value;
        
        // We need to ensure to re-apply the emphasized style if appropriate.
        if (value == null || value is String)
        {
            if (!value || (_emphasized && value.indexOf(" emphasized") == -1))
                emphasizeStyleName();
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    private function emphasizeStyleName():void
    {
        var style:String = styleName is String ? styleName as String : "";
        
        if (!styleName || styleName is String)
        {
            if (_emphasized)
                super.styleName = style + " emphasized";
            else 
                super.styleName = style.split(" emphasized").join("");
        }   
    }
}
}
