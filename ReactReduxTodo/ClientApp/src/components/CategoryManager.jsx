/**
 * CategoryManager Component
 * Sprint 2 - Work Item #3
 * Manages category CRUD operations with React-Bootstrap UI
 */

import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Container, Row, Col, Button, Card, ListGroup, Modal, Form, Badge, Spinner } from 'react-bootstrap';
import {
  fetchCategoriesRequest,
  createCategoryRequest,
  updateCategoryRequest,
  deleteCategoryRequest
} from '../features/categories/actions';
import './CategoryManager.css';

function CategoryManager() {
  const dispatch = useDispatch();
  const { items: categories, loading, error } = useSelector(state => state.categories);

  // Modal states
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);

  // Form states
  const [formData, setFormData] = useState({ name: '', color: '#3498db' });
  const [editingCategory, setEditingCategory] = useState(null);
  const [deletingCategory, setDeletingCategory] = useState(null);

  // Load categories on component mount
  useEffect(() => {
    dispatch(fetchCategoriesRequest());
  }, [dispatch]);

  // Handle form input changes
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  // Handle add category
  const handleAddCategory = (e) => {
    e.preventDefault();
    dispatch(createCategoryRequest(formData));
    setFormData({ name: '', color: '#3498db' });
    setShowAddModal(false);
  };

  // Handle edit category
  const handleEditCategory = (e) => {
    e.preventDefault();
    dispatch(updateCategoryRequest(editingCategory.id, formData));
    setFormData({ name: '', color: '#3498db' });
    setEditingCategory(null);
    setShowEditModal(false);
  };

  // Handle delete category
  const handleDeleteCategory = () => {
    dispatch(deleteCategoryRequest(deletingCategory.id));
    setDeletingCategory(null);
    setShowDeleteModal(false);
  };

  // Open edit modal
  const openEditModal = (category) => {
    setEditingCategory(category);
    setFormData({ name: category.name, color: category.color });
    setShowEditModal(true);
  };

  // Open delete modal
  const openDeleteModal = (category) => {
    setDeletingCategory(category);
    setShowDeleteModal(true);
  };

  return (
    <Container className="category-manager mt-4">
      <Row>
        <Col>
          <div className="d-flex justify-content-between align-items-center mb-3">
            <h2>Category Management</h2>
            <Button variant="primary" onClick={() => setShowAddModal(true)}>
              + Add Category
            </Button>
          </div>

          {error && (
            <div className="alert alert-danger" role="alert">
              {error}
            </div>
          )}

          {loading ? (
            <div className="text-center py-5">
              <Spinner animation="border" role="status">
                <span className="visually-hidden">Loading...</span>
              </Spinner>
            </div>
          ) : (
            <Card>
              <ListGroup variant="flush">
                {categories.length === 0 ? (
                  <ListGroup.Item className="text-center text-muted py-4">
                    No categories yet. Create your first category to organize tasks.
                  </ListGroup.Item>
                ) : (
                  categories.map(category => (
                    <ListGroup.Item key={category.id} className="d-flex justify-content-between align-items-center">
                      <div className="d-flex align-items-center gap-3">
                        <div
                          className="category-color-preview"
                          style={{ backgroundColor: category.color }}
                        />
                        <span className="fw-bold">{category.name}</span>
                        <Badge bg="secondary" pill>{category.color}</Badge>
                      </div>
                      <div className="btn-group">
                        <Button
                          variant="outline-primary"
                          size="sm"
                          onClick={() => openEditModal(category)}
                        >
                          Edit
                        </Button>
                        <Button
                          variant="outline-danger"
                          size="sm"
                          onClick={() => openDeleteModal(category)}
                        >
                          Delete
                        </Button>
                      </div>
                    </ListGroup.Item>
                  ))
                )}
              </ListGroup>
            </Card>
          )}
        </Col>
      </Row>

      {/* Add Category Modal */}
      <Modal show={showAddModal} onHide={() => setShowAddModal(false)}>
        <Modal.Header closeButton>
          <Modal.Title>Add New Category</Modal.Title>
        </Modal.Header>
        <Form onSubmit={handleAddCategory}>
          <Modal.Body>
            <Form.Group className="mb-3">
              <Form.Label>Category Name</Form.Label>
              <Form.Control
                type="text"
                name="name"
                value={formData.name}
                onChange={handleInputChange}
                placeholder="e.g., Work, Personal, Shopping"
                required
                autoFocus
              />
            </Form.Group>
            <Form.Group className="mb-3">
              <Form.Label>Color</Form.Label>
              <div className="d-flex align-items-center gap-3">
                <Form.Control
                  type="color"
                  name="color"
                  value={formData.color}
                  onChange={handleInputChange}
                  required
                  style={{ width: '60px' }}
                />
                <Form.Control
                  type="text"
                  name="color"
                  value={formData.color}
                  onChange={handleInputChange}
                  placeholder="#3498db"
                  required
                />
              </div>
            </Form.Group>
          </Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={() => setShowAddModal(false)}>
              Cancel
            </Button>
            <Button variant="primary" type="submit">
              Create Category
            </Button>
          </Modal.Footer>
        </Form>
      </Modal>

      {/* Edit Category Modal */}
      <Modal show={showEditModal} onHide={() => setShowEditModal(false)}>
        <Modal.Header closeButton>
          <Modal.Title>Edit Category</Modal.Title>
        </Modal.Header>
        <Form onSubmit={handleEditCategory}>
          <Modal.Body>
            <Form.Group className="mb-3">
              <Form.Label>Category Name</Form.Label>
              <Form.Control
                type="text"
                name="name"
                value={formData.name}
                onChange={handleInputChange}
                required
                autoFocus
              />
            </Form.Group>
            <Form.Group className="mb-3">
              <Form.Label>Color</Form.Label>
              <div className="d-flex align-items-center gap-3">
                <Form.Control
                  type="color"
                  name="color"
                  value={formData.color}
                  onChange={handleInputChange}
                  required
                  style={{ width: '60px' }}
                />
                <Form.Control
                  type="text"
                  name="color"
                  value={formData.color}
                  onChange={handleInputChange}
                  required
                />
              </div>
            </Form.Group>
          </Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={() => setShowEditModal(false)}>
              Cancel
            </Button>
            <Button variant="primary" type="submit">
              Save Changes
            </Button>
          </Modal.Footer>
        </Form>
      </Modal>

      {/* Delete Confirmation Modal */}
      <Modal show={showDeleteModal} onHide={() => setShowDeleteModal(false)}>
        <Modal.Header closeButton>
          <Modal.Title>Delete Category</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          Are you sure you want to delete the category "{deletingCategory?.name}"?
          This action cannot be undone.
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={() => setShowDeleteModal(false)}>
            Cancel
          </Button>
          <Button variant="danger" onClick={handleDeleteCategory}>
            Delete
          </Button>
        </Modal.Footer>
      </Modal>
    </Container>
  );
}

export default CategoryManager;
