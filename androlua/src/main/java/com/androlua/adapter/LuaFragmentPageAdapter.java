package com.androlua.adapter;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentStatePagerAdapter;

public class LuaFragmentPageAdapter extends FragmentStatePagerAdapter {

    private AdapterCreator creator;

    public LuaFragmentPageAdapter(FragmentManager fm, AdapterCreator creator) {
        super(fm);
        this.creator = creator;
    }

    @Override
    public Fragment getItem(int position) {
        return creator.getItem(position);
    }

    @Override
    public int getCount() {
        return (int) creator.getCount();
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return creator.getPageTitle(position);
    }

    public interface AdapterCreator {
        long getCount();
        Fragment getItem(int position);
        String getPageTitle(int position);
    }
}