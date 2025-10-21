/**
 * Reducer for Category Management
 * Sprint 2 - Work Item #3
 */

import * as types from './actionTypes';

const initialState = {
  items: [],
  loading: false,
  error: null
};

export default function categoriesReducer(state = initialState, action) {
  switch (action.type) {
    // Fetch categories
    case types.FETCH_CATEGORIES_REQUEST:
      return {
        ...state,
        loading: true,
        error: null
      };

    case types.FETCH_CATEGORIES_SUCCESS:
      return {
        ...state,
        items: action.payload,
        loading: false,
        error: null
      };

    case types.FETCH_CATEGORIES_FAILURE:
      return {
        ...state,
        loading: false,
        error: action.payload
      };

    // Create category
    case types.CREATE_CATEGORY_REQUEST:
      return {
        ...state,
        loading: true,
        error: null
      };

    case types.CREATE_CATEGORY_SUCCESS:
      return {
        ...state,
        items: [...state.items, action.payload],
        loading: false,
        error: null
      };

    case types.CREATE_CATEGORY_FAILURE:
      return {
        ...state,
        loading: false,
        error: action.payload
      };

    // Update category
    case types.UPDATE_CATEGORY_REQUEST:
      return {
        ...state,
        loading: true,
        error: null
      };

    case types.UPDATE_CATEGORY_SUCCESS:
      return {
        ...state,
        items: state.items.map(item =>
          item.id === action.payload.id ? action.payload : item
        ),
        loading: false,
        error: null
      };

    case types.UPDATE_CATEGORY_FAILURE:
      return {
        ...state,
        loading: false,
        error: action.payload
      };

    // Delete category
    case types.DELETE_CATEGORY_REQUEST:
      return {
        ...state,
        loading: true,
        error: null
      };

    case types.DELETE_CATEGORY_SUCCESS:
      return {
        ...state,
        items: state.items.filter(item => item.id !== action.payload),
        loading: false,
        error: null
      };

    case types.DELETE_CATEGORY_FAILURE:
      return {
        ...state,
        loading: false,
        error: action.payload
      };

    default:
      return state;
  }
}
