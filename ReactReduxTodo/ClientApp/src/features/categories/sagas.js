/**
 * Sagas for Category Management
 * Sprint 2 - Work Item #3
 * Handles async API calls for category operations
 */

import { call, put, takeLatest } from 'redux-saga/effects';
import * as types from './actionTypes';
import * as actions from './actions';

// API endpoints
const API_BASE = '/api/categories';

// API helper functions
async function fetchCategoriesApi() {
  const response = await fetch(API_BASE);
  if (!response.ok) {
    throw new Error('Failed to fetch categories');
  }
  return response.json();
}

async function createCategoryApi(category) {
  const response = await fetch(API_BASE, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(category)
  });
  if (!response.ok) {
    throw new Error('Failed to create category');
  }
  return response.json();
}

async function updateCategoryApi(id, category) {
  const response = await fetch(`${API_BASE}/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(category)
  });
  if (!response.ok) {
    throw new Error('Failed to update category');
  }
  return response.json();
}

async function deleteCategoryApi(id) {
  const response = await fetch(`${API_BASE}/${id}`, {
    method: 'DELETE'
  });
  if (!response.ok) {
    throw new Error('Failed to delete category');
  }
  return id;
}

// Saga workers
function* fetchCategoriesSaga() {
  try {
    const categories = yield call(fetchCategoriesApi);
    yield put(actions.fetchCategoriesSuccess(categories));
  } catch (error) {
    yield put(actions.fetchCategoriesFailure(error.message));
  }
}

function* createCategorySaga(action) {
  try {
    const category = yield call(createCategoryApi, action.payload);
    yield put(actions.createCategorySuccess(category));
  } catch (error) {
    yield put(actions.createCategoryFailure(error.message));
  }
}

function* updateCategorySaga(action) {
  try {
    const { id, category } = action.payload;
    const updatedCategory = yield call(updateCategoryApi, id, category);
    yield put(actions.updateCategorySuccess(updatedCategory));
  } catch (error) {
    yield put(actions.updateCategoryFailure(error.message));
  }
}

function* deleteCategorySaga(action) {
  try {
    yield call(deleteCategoryApi, action.payload);
    yield put(actions.deleteCategorySuccess(action.payload));
  } catch (error) {
    yield put(actions.deleteCategoryFailure(error.message));
  }
}

// Saga watchers
export default function* categoriesSaga() {
  yield takeLatest(types.FETCH_CATEGORIES_REQUEST, fetchCategoriesSaga);
  yield takeLatest(types.CREATE_CATEGORY_REQUEST, createCategorySaga);
  yield takeLatest(types.UPDATE_CATEGORY_REQUEST, updateCategorySaga);
  yield takeLatest(types.DELETE_CATEGORY_REQUEST, deleteCategorySaga);
}
