package com.androlua.fragment;

import android.content.Context;
import android.os.Bundle;
import android.content.res.Configuration;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class LuaFragment extends Fragment {

    private FragmentCreator creator;

    public static LuaFragment newInstance() {
        Bundle args = new Bundle();
        LuaFragment fragment = new LuaFragment();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onPause() {
        super.onPause();
        if (creator != null) {
            creator.onPause();
        }
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
         if (creator != null) {
             creator.onUserVisible(isVisibleToUser);
         }
    }

    public void setCreator(FragmentCreator creator) {
        this.creator = creator;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (creator != null)creator.onAttach(context);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        if (creator != null)creator.onCreate(savedInstanceState);
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        if (creator != null) {
            return creator.onCreateView(inflater, container, savedInstanceState);
        }
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (creator != null)creator.onActivityCreated(savedInstanceState);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        if (creator != null)creator.onViewCreated(view, savedInstanceState);
    }
    
   @Override
    public void onViewStateRestored(@Nullable Bundle savedInstanceState) {
        super.onViewStateRestored(savedInstanceState);
        if (creator != null)creator.onViewStateRestored(savedInstanceState);
    }
    
    @Override
    public void onStart() {
        if (creator != null) creator.onStart();
        super.onStart();
    }

    @Override
    public void onResume() {
        if (creator != null)creator.onResume();
        super.onResume();
    }

    @Override
    public void onStop() {
        if (creator != null)creator.onStop();
        super.onStop();
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        if (creator != null)creator.onDestroyView();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (creator != null)creator.onDestroy();
    }

    @Override
    public void onDetach() {
        super.onDetach();
        if (creator != null)creator.onDetach();
    }
    
   @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        if (creator != null)creator.onSaveInstanceState(outState);
    }

   @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (creator != null)creator.onConfigurationChanged(newConfig);
    }

    public interface FragmentCreator {
        void onCreate(@Nullable Bundle savedInstanceState);

        void onAttach(Context context);

        View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState);

        void onActivityCreated(Bundle savedInstanceState);

        void onViewCreated(View view, @Nullable Bundle savedInstanceState);

        void onViewStateRestored(@Nullable Bundle savedInstanceState);

        void onSaveInstanceState(Bundle savedInstanceState);

        void onConfigurationChanged(Configuration newConfig);

        void onStart();

        void onResume();

        void onStop();

        void onPause();

        void onDestroyView();

        void onDestroy();

        void onDetach();

        void onUserVisible(boolean isVisibleToUser);

    }
}
