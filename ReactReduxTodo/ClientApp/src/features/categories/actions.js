/**
 * Action Creators for Category Management
 * Sprint 2 - Work Item #3
 */

import * as types from './actionTypes';

// Fetch categories
export const fetchCategoriesRequest = () => ({
  type: types.FETCH_CATEGORIES_REQUEST
});

export const fetchCategoriesSuccess = (categories) => ({
  type: types.FETCH_CATEGORIES_SUCCESS,
  payload: categories
});

export const fetchCategoriesFailure = (error) => ({
  type: types.FETCH_CATEGORIES_FAILURE,
  payload: error
});

// Create category
export const createCategoryRequest = (category) => ({
  type: types.CREATE_CATEGORY_REQUEST,
  payload: category
});

export const createCategorySuccess = (category) => ({
  type: types.CREATE_CATEGORY_SUCCESS,
  payload: category
});

export const createCategoryFailure = (error) => ({
  type: types.CREATE_CATEGORY_FAILURE,
  payload: error
});

// Update category
export const updateCategoryRequest = (id, category) => ({
  type: types.UPDATE_CATEGORY_REQUEST,
  payload: { id, category }
});

export const updateCategorySuccess = (category) => ({
  type: types.UPDATE_CATEGORY_SUCCESS,
  payload: category
});

export const updateCategoryFailure = (error) => ({
  type: types.UPDATE_CATEGORY_FAILURE,
  payload: error
});

// Delete category
export const deleteCategoryRequest = (id) => ({
  type: types.DELETE_CATEGORY_REQUEST,
  payload: id
});

export const deleteCategorySuccess = (id) => ({
  type: types.DELETE_CATEGORY_SUCCESS,
  payload: id
});

export const deleteCategoryFailure = (error) => ({
  type: types.DELETE_CATEGORY_FAILURE,
  payload: error
});
