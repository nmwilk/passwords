package com.measuredsoftware.passvault.model;

import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;

/**
 * Created by neil on 08/03/16.
 */
public class NavigationClickHandler
{
    private final PasswordListAdapter dataModel;
    private final DrawerLayout drawerLayout;

    public NavigationClickHandler(final PasswordListAdapter dataModel, final DrawerLayout drawerLayout)
    {

        this.dataModel = dataModel;
        this.drawerLayout = drawerLayout;
    }

    public boolean toggleEditModeOnClick(final boolean scrolling)
    {
        boolean toggle = false;
        if (dataModel.getMode() == PasswordListAdapter.Mode.EDIT)
        {
            if (!scrolling)
            {
                toggle = true;
            }
        }
        else if (drawerLayout.isDrawerOpen(GravityCompat.START))
        {
            drawerLayout.closeDrawer(GravityCompat.START);
        }
        else
        {
            drawerLayout.openDrawer(GravityCompat.START);
        }

        return toggle;
    }
}
