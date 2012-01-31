////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2009 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package spark.accessibility
{

import flash.accessibility.AccessibilityImplementation;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;

import mx.accessibility.AccConst;
import mx.accessibility.AccImpl;
import mx.accessibility.PanelAccImpl;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.ResizeEvent;

import spark.components.Panel;
import spark.components.supportClasses.TextBase;
import spark.events.SkinPartEvent;

use namespace mx_internal;

/**
 *  PanelAccImpl is the accessibility implementation class
 *  for spark.components.Panel.
 *
 *  <p>When a Spark Panel is created,
 *  the <code>accessibilityImplementation</code> property
 *  of a special child Sprite is set to an instance of this class.
 *  The Flash Player then uses this class to allow MSAA clients
 *  such as screen readers to see and manipulate the Panel.
 *  See the mx.accessibility.AccImpl and
 *  flash.accessibility.AccessibilityImplementation classes
 *  for background information about accessibility implementation
 *  classes and MSAA.</p>
 *
 *  <p><b>Children</b></p>
 *
 *  <p>A Panel has no MSAA children.
 *  All children of the actual Panel are siblings of the Panel
 *  in the FlashPlayer's MSAA tree, because Flash Player
 *  does not support objects with accessibility implementations
 *  having children with their own accessibility implementations.</p>
 *
 *  <p>The PanelAccImpl is set as the <code>accessibilityImplementation</code>
 *  of the <code>titleDisplay</code> object because setting it on the Panel
 *  itself would not allow the Panel's children to be exposed in MSAA.
 *  Because of this an invisible rectangle is drawn in the
 *  <code>titleDisplay</code> making it the same size as the Panel as a whole
 *  so that the MSAA Location is the bounding rectangle of the entire Panel.
 *  Screen readers like JAWS rely on the MSAA Location to announce whether
 *  some component is in the grouping since the MSAA structure is flat.</p>
 *
 *  <p><b>Role</b></p>
 *
 *  <p>The MSAA Role of a Panel is ROLE_SYSTEM_GROUPING.</p>
 *
 *  <p><b>Name</b></p>
 *
 *  <p>The MSAA Name of a Panel is, by default, the title that it displays.
 *  To override this behavior, set the Panel's <code>accessibilityName</code>
 *  property.</p>
 *
 *  <p>When the Name changes,
 *  a Panel dispatches the MSAA event EVENT_OBJECT_NAMECHANGE.</p>
 *
 *  <p><b>Description</b></p>
 *
 *  <p>The MSAA Description of a Panel is, by default, the empty string,
 *  but you can set the Panel's <code>accessibilityDescription</code>
 *  property.</p>
 *
 *  <p><b>State</b></p>
 *
 *  <p>The MSAA State of a Panel is always STATE_SYSTEM_NORMAL,
 *  indicating that no state flags are set.</p>
 *
 *  <p>Since the state does not change,
 *  a Panel does not dispatch the MSAA event EVENT_OBJECT_STATECHANGE.</p>
 *
 *  <p><b>Value</b></p>
 *
 *  <p>The MSAA Value of a Panel is always the empty string.</p>
 *
 *  <p><b>Location</b></p>
 *
 *  <p>The MSAA Location of a Panel is its bounding rectangle.</p>
 *
 *  <p><b>Default Action</b></p>
 *
 *  <p>A Panel does not have an MSAA DefaultAction .</p>
 *
 *  <p><b>Focus</b></p>
 *
 *  <p>A Panel does not accept focus.</p>
 *
 *  <p><b>Selection</b></p>
 *
 *  <p>A Panel does not support selection in the MSAA sense.</p>
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class PanelAccImpl extends AccImpl
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Enables accessibility in the Panel class.
     *
     *  <p>This method is called by application startup code
     *  that is autogenerated by the MXML compiler.
     *  Afterwards, when instances of Panel are initialized,
     *  the <code>accessibilityImplementation</code> property
     *  of a special first child Sprite will be set to an instance
	 *  of this class.
	 *  If the PanelAccImpl were attached to the Panel itself
	 *  the accessibility implementations of the Panel's children
	 *  would be ignored.</p>
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static function enableAccessibility():void
    {
        Panel.createAccessibilityImplementation =
            createAccessibilityImplementation;
    }

    /**
     *  @private
     *  Creates Panel's AccessibilityImplementation object.
	 *  This method is called from Panel's initializeAccessibility() method.
     */
    mx_internal static function createAccessibilityImplementation(
                                component:UIComponent):void
    {
		// The TitleWindowAccImpl is attached
		// not to the TitleWindow but to a special child Sprite.
		// If it were attached to the TitleWindow itself,
		// the AccessibilityImplementations of the TitleWindow's
		// children would be ignored.
		var accImpl:PanelAccImpl = new PanelAccImpl(component);
		accImpl.attach();
    }
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param master The UIComponent instance that this AccImpl instance
     *  is making accessible.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function PanelAccImpl(master:UIComponent)
    {
        super(master);

        role = AccConst.ROLE_SYSTEM_GROUPING;
    }

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 *  A Sprite which gets added to the Panel for the sole purpose
	 *  of holding the PanelAccImpl.
	 *  We have to make sure that the size of this Sprite is the same
	 *  as the size of the Panel so that the MSAA Location is correct.
	 */
	mx_internal var accImplSprite:Sprite;
	
	/**
	 *  @private
	 *  If the titleDisplay keeps an acc impl, it shows up as an accessible
	 *  object, in addition to the accImplSprite.
	 *  To prevent this, we remove the acc impl from the titleDisplay
	 *  and park it here.
	 */
	private var titleDisplayAccImpl:AccessibilityImplementation;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden properties: AccImpl
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  eventsToHandle
	//----------------------------------
	
	/**
	 *  @private
	 *  Array of events that we should listen for from the master component.
	 */
	override protected function get eventsToHandle():Array
	{
		return super.eventsToHandle.concat([ ResizeEvent.RESIZE,
											 SkinPartEvent.PART_ADDED,
											 SkinPartEvent.PART_REMOVED ]);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: AccessibilityImplementation
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  IAccessible method for returning the state of the Panel.
     *  States are predefined for all the components in MSAA. Values are assigned to each state.
     *  Depending upon the Panel being Focusable, Focused and Moveable, a value is returned.
     *
     *  @param childID:int
     *
     *  @return State:uint
     */
    override public function get_accState(childID:uint):uint
    {
        var accState:uint = getState(childID);

        return accState;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: AccImpl
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  method for returning the name of the Panel
     *  which is spoken out by the screen reader
     *  The Panel should return the Title as the name.
     *
     *  @param childID:uint
     *
     *  @return Name:String
     */
    override protected function getName(childID:uint):String
    {
        return Panel(master).title;
    }
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  The AccessibilityImplementation is placed
	 *  not on the Panel but on a special child Sprite.
	 *  If it were placed on the Panel itself,
	 *  the AccessibilityImplementations of the Panel's
	 *  children would be ignored.
	 */
	mx_internal function attach():Sprite
	{
		var panel:Panel = Panel(master);
		
		// Create a Sprite.
		accImplSprite = new Sprite();
		
		// Add the Sprite as the first child of the component.
		panel.$addChildAt(accImplSprite, 0);
		
		// Attach this acc impl to this Sprite.
		accImplSprite.accessibilityImplementation = this;
		
		// Remove and save the titleDisplay's acc impl
		// so that a screen reader doesn't read the title twice.
		if (panel.titleDisplay)
		{
			titleDisplayAccImpl =
				panel.titleDisplay.accessibilityImplementation;
			panel.titleDisplay.accessibilityImplementation = null;
		}
		
		if (panel.tabIndex > 0 && accImplSprite.tabIndex == -1)
			accImplSprite.tabIndex = panel.tabIndex;
		
		return accImplSprite;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden event handlers: AccImpl
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 *  Override the generic event handler.
	 *  All AccImpl must implement this
	 *  to listen for events from its master component.
	 */
	override protected function eventHandler(event:Event):void
	{
		super.eventHandler(event);
		
		var titleDisplay:TextBase;

		switch (event.type)
		{
			case ResizeEvent.RESIZE:
			{
				// In the accImplSprite, draw an invisible unfilled rect
				// around the bounds of the entire Panel.
				// This is for accessibility; the accImplSprite of the Panel
				// has an AccessibilityImplementation (see PanelAccImpl)
				// which makes it act like a grouping (ROLE_SYSTEM_GROUPING)
				// for the controls inside the panel.
				// Drawing this rect makes the accLocation rect of the grouping
				// enclose the controls inside the grouping,
				// even though it is a sibling of them, not their parent.
				// (This is because the Player doesn't support Sprites
				// with AccessibilityImplementations inside other Sprites
				// with AccessibilityImplementations; the accessible objects
				// in a Flash SWF are a flat list, not a hierarchy.)
				var panel:Panel = Panel(master);
				var g:Graphics = accImplSprite.graphics;
				g.clear();
				g.lineStyle(0, 0x000000, 0);
				g.drawRect(0, 0, panel.width, panel.height);
				break;
			}
				
			case SkinPartEvent.PART_ADDED:
			{
				titleDisplay = Panel(master).titleDisplay;
				if (SkinPartEvent(event).instance == titleDisplay)
				{
					titleDisplayAccImpl = titleDisplay.accessibilityImplementation;
					titleDisplay.accessibilityImplementation = null;
				}
				break;
			}
				
			case SkinPartEvent.PART_REMOVED:
			{
				titleDisplay = Panel(master).titleDisplay;
				if (SkinPartEvent(event).instance == titleDisplay)
				{
					titleDisplay.accessibilityImplementation = titleDisplayAccImpl;
					titleDisplayAccImpl = null;
				}
				break;
			}
		}
	}
}

}
