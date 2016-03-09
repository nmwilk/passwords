// Copyright 2014 Neil Wilkinson
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package com.measuredsoftware.passvault.model;

import android.content.Context;
import android.content.SharedPreferences;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import com.google.gson.Gson;
import com.measuredsoftware.passvault.view.PasswordList;
import com.measuredsoftware.passvault.view.PasswordListItem;

import java.util.Comparator;
import java.util.Set;
import java.util.TreeSet;

/**
 * Main model for the password list. Adapts the data into Views.
 */
public class PasswordListAdapter extends ArrayAdapter<PasswordModel>
    implements PasswordListItem.DeleteItemListener
{
    public enum Mode
    {
        NORMAL,
        EDIT
    }

    private static final String PASSWORD_KEY = "fihrbkefjebke";

    public static final String PASSWORD_STORE = "com.measuredsoftware.passvault";

    private final Comparator<? super PasswordModel> sorter;
    private final PasswordList listView;

    private int maxIdFound;

    private PasswordListItem.EditItemListener editItemListener;

    private Mode mode;

    public PasswordListAdapter(final Context context, final PasswordList listView)
    {
        super(context, 0);

        this.listView = listView;
        mode = Mode.NORMAL;

        sorter = new Comparator<PasswordModel>()
        {
            @Override
            public int compare(final PasswordModel lhs, final PasswordModel rhs)
            {
                return lhs.getName().compareToIgnoreCase(rhs.getName());
            }
        };

        loadPasswords();
    }

    public void setEditItemListener(final PasswordListItem.EditItemListener editItemListener)
    {
        this.editItemListener = editItemListener;
    }

    public void setMode(final Mode mode)
    {
        if (mode != this.mode)
        {
            this.mode = mode;
        }
    }


    public boolean isEmpty()
    {
        return getCount() == 0;
    }

    public Mode getMode()
    {
        return mode;
    }

    public void addPassword(final PasswordModel model)
    {
        model.setId(++maxIdFound);
        add(model);
        storePasswords();
    }

    /**
     * @param model instance to update the matching {@link com.measuredsoftware.passvault.model.PasswordModel} with. Will add the instance if it is not found.
     */
    public void editPassword(final PasswordModel model)
    {
        PasswordModel oldVersion = null;
        for (int i = 0; i < getCount(); i++)
        {
            if (model.equals(getItem(i)))
            {
                oldVersion = model;
                break;
            }
        }

        if (oldVersion == null)
        {
            addPassword(model);
        }
        else
        {
            remove(oldVersion);
            add(model);
            storePasswords();
        }
    }

    @SuppressWarnings("ConstantConditions")
    public void deletePassword(final PasswordModel model)
    {
        listView.animateViewRemoval(model);
    }

    private void loadPasswords()
    {
        final Gson gson = new Gson();
        final SharedPreferences preferences = getContext().getSharedPreferences(PASSWORD_STORE, Context.MODE_PRIVATE);
        final Set<String> storedGson = preferences.getStringSet(PASSWORD_KEY, new TreeSet<String>());

        for (final String item : storedGson)
        {
            final PasswordModel passwordModel = gson.fromJson(item, PasswordModel.class);
            if (passwordModel.getId() > maxIdFound)
            {
                maxIdFound = passwordModel.getId();
            }
            add(passwordModel);
        }

        notifyDataSetChanged();
    }

    @Override
    public long getItemId(final int position)
    {
        return getItem(position).getId();
    }

    @Override
    public void add(final PasswordModel model)
    {
        super.add(model);
        sort();
    }

    @Override
    public void remove(final PasswordModel object)
    {
        super.remove(object);
        sort();
    }

    @Override
    public View getView(final int position, final View convertView, final ViewGroup parent)
    {
        final PasswordListItem view;

        if (convertView == null)
        {
            view = new PasswordListItem(getContext());
            view.setDeleteItemListener(this);
            view.setEditItemListener(editItemListener);
        }
        else
        {
            view = (PasswordListItem) convertView;
        }

        view.setTransitionEnabled(false);
        view.configure(getItem(position), mode);

        return view;
    }

    @Override
    public void onItemDeleted(final PasswordModel item)
    {
        deletePassword(item);
    }

    public void sort()
    {
        sort(sorter);
    }

    public void storePasswords()
    {
        final Gson gson = new Gson();

        final Set<String> sortedList = new TreeSet<String>();
        for (int i = 0; i < getCount(); i++)
        {
            sortedList.add(gson.toJson(getItem(i)));
        }

        final SharedPreferences.Editor editor = getContext().getSharedPreferences(PASSWORD_STORE, Context.MODE_PRIVATE).edit();
        editor.putStringSet(PASSWORD_KEY, sortedList);
        editor.commit();
    }

    @Override
    public boolean hasStableIds()
    {
        return true;
    }
}
