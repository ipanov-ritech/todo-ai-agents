import { useState } from 'react';
import { connect } from 'react-redux';
import { Button, Badge, Form } from 'react-bootstrap';
import { deleteTask, setDueDate } from '../features/taskList/actions';

const getDueDateStatus = (dueDate) => {
  if (!dueDate) return null;
  const now = new Date();
  const due = new Date(dueDate);
  const hoursUntilDue = (due - now) / (1000 * 60 * 60);

  if (hoursUntilDue < 0) return 'overdue';
  if (hoursUntilDue <= 24) return 'warning';
  return 'normal';
};

const formatDate = (dateString) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
};

const TaskRaw = (props) => {
  const [showDatePicker, setShowDatePicker] = useState(false);
  const dueDateStatus = getDueDateStatus(props.data.dueDate);

  const handleDateChange = (e) => {
    const newDate = e.target.value ? new Date(e.target.value).toISOString() : null;
    props.setDueDate(props.data.id, newDate);
    setShowDatePicker(false);
  };

  const getBadgeVariant = () => {
    switch (dueDateStatus) {
      case 'overdue':
        return 'danger';
      case 'warning':
        return 'warning';
      default:
        return 'secondary';
    }
  };

  const getRowStyle = () => {
    if (dueDateStatus === 'overdue') {
      return { backgroundColor: '#ffebee' };
    }
    return {};
  };

  return (
    <tr style={getRowStyle()}>
      <td>{props.data.id}</td>
      <td>{props.data.description}</td>
      <td>
        {props.data.dueDate ? (
          <Badge bg={getBadgeVariant()} className="me-2">
            {dueDateStatus === 'overdue' && '⚠️ '}
            {dueDateStatus === 'warning' && '⏰ '}
            {formatDate(props.data.dueDate)}
          </Badge>
        ) : (
          <span className="text-muted">No due date</span>
        )}
        {showDatePicker ? (
          <Form.Control
            type="date"
            size="sm"
            style={{ width: '150px', display: 'inline-block' }}
            onChange={handleDateChange}
            onBlur={() => setShowDatePicker(false)}
            autoFocus
          />
        ) : (
          <Button
            variant="outline-secondary"
            size="sm"
            onClick={() => setShowDatePicker(true)}
          >
            📅
          </Button>
        )}
      </td>
      <td>
        <Button variant="danger" onClick={() => props.deleteTask(props.data.id)}>
          Delete
        </Button>
      </td>
    </tr>
  );
};

const actionCreators = { deleteTask, setDueDate };

export const Task = connect(null, actionCreators)(TaskRaw);
