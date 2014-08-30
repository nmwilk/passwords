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

package com.measuredsoftware.passvault.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import java.util.HashMap;
import java.util.Map;

/**
 * Animates the removal of list items.
 */
public abstract class AnimatedListView<T> extends ListView
{
    private final Runnable endActionRunnable;
    private long fillSpaceAnimationDuration = 300;
    private long deleteAnimationDuration = 200;

    private final Map<Long, Integer> itemIdTopMap = new HashMap<Long, Integer>();
    private BackgroundContainer backgroundContainer;
    private View removedView;

    public AnimatedListView(final Context context, final AttributeSet attrs)
    {
        super(context, attrs);

        endActionRunnable = new Runnable()
        {
            @Override
            public void run()
            {
                hideBackground();
                setEnabled(true);
                removedView.setAlpha(1);
            }
        };
    }

    @SuppressWarnings("UnusedDeclaration")
    public void setFillSpaceAnimationDuration(final long fillSpaceAnimationDuration)
    {
        this.fillSpaceAnimationDuration = fillSpaceAnimationDuration;
    }

    @SuppressWarnings("UnusedDeclaration")
    public void setDeleteAnimationDuration(final long deleteAnimationDuration)
    {
        this.deleteAnimationDuration = deleteAnimationDuration;
    }

    @Override
    public ArrayAdapter<T> getAdapter()
    {
        return (ArrayAdapter<T>) super.getAdapter();
    }

    @SuppressWarnings("ConstantConditions")
    /**
     * Animates the removal of the supplied model from the list, and then calls {@link #animateFillSpace(Object)} to slide the rest into position.
     */
    public void animateViewRemoval(final T item)
    {
        if (!getAdapter().hasStableIds())
        {
            throw new IllegalStateException("Adapter of " + getClass().getSimpleName() + " must have stable ids.");
        }

        View view = null;
        int removedIndex = -1;

        for (int i = 0; i < getChildCount(); i++)
        {
            final PasswordListItem child = (PasswordListItem) getChildAt(i);
            if (child.getItem() == item)
            {
                view = child;
                removedIndex = i;
                break;
            }
        }

        removedView = view;

        setEnabled(false);
        if (removedIndex < getChildCount() - 1)
        {
            showBackground(removedView.getTop(), removedView.getHeight());
        }

        removedView.animate().alpha(0).setDuration(deleteAnimationDuration).withEndAction(new Runnable()
        {
            @Override
            public void run()
            {
                animateFillSpace(item);
            }
        });

    }

    @SuppressWarnings("ConstantConditions")
    private void animateFillSpace(final T item)
    {
        final int firstVisiblePosition = getFirstVisiblePosition();

        for (int i = 0; i < getChildCount(); i++)
        {
            final PasswordListItem child = (PasswordListItem) getChildAt(i);
            if (child.getItem() != item)
            {
                final int position = firstVisiblePosition + i;
                final long itemId = getAdapter().getItemId(position);
                itemIdTopMap.put(itemId, child.getTop());
            }
        }

        getAdapter().remove(item);

        final ViewTreeObserver observer = getViewTreeObserver();
        observer.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener()
        {
            @Override
            public boolean onPreDraw()
            {
                observer.removeOnPreDrawListener(this);
                boolean firstAnimation = true;
                final int firstVisiblePosition = getFirstVisiblePosition();
                for (int i = 0; i < getChildCount(); ++i)
                {
                    final View child = getChildAt(i);
                    final int position = firstVisiblePosition + i;
                    final long itemId = getAdapter().getItemId(position);

                    Integer startTop = itemIdTopMap.get(itemId);
                    final int top = child.getTop();

                    final int delta;

                    if (startTop == null)
                    {
                        final int childHeight = child.getHeight() + getDividerHeight();
                        startTop = top + (i > 0 ? childHeight : -childHeight);
                        delta = startTop - top;
                    }
                    else if (startTop == top)
                    {
                        continue;
                    }
                    else
                    {
                        delta = startTop - top;
                    }

                    child.setTranslationY(delta);
                    child.setAlpha(1);
                    child.animate().setDuration(fillSpaceAnimationDuration).translationY(0);
                    if (firstAnimation)
                    {
                        child.animate().withEndAction(endActionRunnable);
                        firstAnimation = false;
                    }
                }

                itemIdTopMap.clear();
                return true;
            }
        });

    }

    @Override
    protected void onLayout(final boolean changed, final int l, final int t, final int r, final int b)
    {
        super.onLayout(changed, l, t, r, b);

        if (getParent() instanceof BackgroundContainer)
        {
            backgroundContainer = (BackgroundContainer) getParent();
        }
    }

    public void hideBackground()
    {
        if (backgroundContainer != null)
        {
            backgroundContainer.hideBackground();
        }
    }

    public void showBackground(final int rowTop, final int rowHeight)
    {
        if (backgroundContainer != null)
        {
            backgroundContainer.showBackground(rowTop, rowHeight);
        }
    }
}
